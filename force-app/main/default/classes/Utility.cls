public class Utility {

  public static HTTPResponse makeCallout(String calloutName, String requestBody, String endpoint, Map<String, String> additionalHeaders, String methodName){
          return makeCallout(calloutName, requestBody, null, endpoint, additionalHeaders, methodName);
      }

      public static HTTPResponse makeCallout(String calloutName, String requestBody, Blob requestBodyBlob, String endpoint, Map<String, String> additionalHeaders, String methodName){



          system.debug('CALLOUT_REQUEST : ' + requestBody);
          system.debug('Custom Setting Name : ' + calloutName);
          system.debug('Endpoint : ' + endpoint);

          HttpRequest req = new HttpRequest();
          Http http = new Http();
          HTTPResponse res = new HTTPResponse();

          NamedCredentialsUtils.service = calloutName;
          Named_Credential_Mapping__mdt credentialMapping = cachedMap.get(calloutName);

          if(String.isBlank(endpoint)) {
              endpoint = 'callout:';
              endPoint += ((isProduction) ? credentialMapping.Production__c : credentialMapping.Sandbox__c); 
          }

          if( !endpoint.tolowerCase().startsWith('callout:') ) throw new NamedCredentialException('Please put your callout into a Named Credential');


          if(additionalHeaders != null) {
              for(String headerName : additionalHeaders.keyset()){
                  String headerValueFromMap = additionalHeaders.get(headerName);
                  req.setHeader(headerName, headerValueFromMap);
              }
          }

          //----Set remaining parameters from custom setting, or what's passed into this class----//
          req.setMethod(methodName);
          req.setEndpoint(endpoint);

          if(credentialMapping.Timeout__c != null) req.setTimeout(Integer.ValueOf(credentialMapping.Timeout__c));

          if(requestBodyBlob != null)     req.setBodyAsBlob(requestBodyBlob);
          else if(requestBody != null)    req.setBody(requestBody);

          //----Make callout. Return the response----//

          res = http.send(req);

          Integer statuscode = res.getStatusCode();
          boolean calloutFailed = String.ValueOf(statuscode).startsWith('20') ? FALSE : TRUE;

          if( (calloutFailed && credentialMapping.Send_Failure_To_splunk__c == true)
             || (!calloutFailed && credentialMapping.Send_Success_To_splunk__c == true)
          ) {

              String reqEndPoint = (req == null) ? null : req.getEndpoint();
              String responseBody = res.getBody();
              String logLevel = calloutFailed ? 'Error' : 'Debug'; 
              String logStatus = calloutFailed ? 'Error' : 'Success';



              SplunkLogger.SplunkLogWrapper wrapper = new SplunkLogger.splunkLogWrapper(
                                  'Callout', calloutName, '', 
                                   logStatus, logLevel, '', null, null,
                                   reqEndPoint, null, responseBody, statuscode)  ;
              SplunkLogger.queueSplunkLogs(new list<SplunkLogger.SplunkLogWrapper> {wrapper});
          }

          return res; 
      }
}
