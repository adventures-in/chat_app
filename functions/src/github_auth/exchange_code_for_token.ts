// --- Relevant resources ---
//
// firebase/functions-samples > authorized-https-endpoint
// https://github.com/firebase/functions-samples/blob/master/authorized-https-endpoint/functions/index.js
// 
// cors 
// https://github.com/expressjs/cors
// 
// Using cors with typescript 
// https://brianflove.com/2017-03-22/express-cors-typescript/
// 
// Using existing express apps in cloud functions 
// https://firebase.google.com/docs/functions/http-events#using_existing_express_apps

import * as functions from 'firebase-functions';
import * as express from 'express';
import * as cors from 'cors';
import * as rp from 'request-promise';

export const exchangeCodeWithGitHub = express();

// get the code from the request, call retrieveAuthToken and return the response
const exchangeCodeForToken = async (req: any, resp: any) => {
  try {
    const auth_token = await retrieveAuthToken(req.get('code'));
    return resp.send(auth_token);
  } catch(error) {
    console.error(error);
    return resp.status(500).send('Something went wrong while exchanging the code.');
  }
};

// Exchange the code from github (plus a secret) for an auth token 
function retrieveAuthToken(code: string = '') {
  return rp({
    method: 'POST',
    uri: 'https://github.com/login/oauth/access_token',
    body: {
      code: code,
      client_id: functions.config().github.client_id,
      client_secret: functions.config().github.client_secret,
    },
    json: true,
  });
}

exchangeCodeWithGitHub.use(cors());
exchangeCodeWithGitHub.use(exchangeCodeForToken);