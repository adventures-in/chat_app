import * as functions from 'firebase-functions';

// The Firebase Admin SDK to access the Firestore.
import * as admin from 'firebase-admin';
admin.initializeApp();
const db = admin.firestore();

export const saveDetailsOnFirstSignIn = functions.auth.user().onCreate((user) => {
    return db.doc('/users/'+user.uid).set({
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL, 
        'phoneNumber': user.phoneNumber
    });
});
