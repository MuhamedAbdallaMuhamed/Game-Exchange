const functions = require('firebase-functions');
const admin = require('firebase-admin');
 
admin.initializeApp(functions.config().functions);
 
var newData;
 
exports.myTrigger = functions.firestore.document('Cgs/{id}').onCreate(async (snapshot, context) => {
    //
 
    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }   
 
    try {
        console.log('Notification sent successfully');
    } catch (err) {
        console.log(err);
    }
});
