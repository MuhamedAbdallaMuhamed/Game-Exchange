//-----------------------------------Libiraries-----------------------------------//
const SOCKET_LIB = 'socket.io';
const HTTP_LIB = 'http';
const EXPRESS_LIB = 'express';
//-----------------------------------Keys------------------------------------------//
const SERVER_NONE = '/';
const SERVER_CONNECT = 'connection';
const SERVER_DISCONNECT = 'disconnect';
const SERVER_SEND = 'Send';
const SERVER_RECERIVE = 'Recerive';
const MessageID = 'MessageID';
const Content = 'Content';
const Time = 'Time';
const SenderID = 'SenderID';
const ReceiverID = 'ReceiverID';
const MainPath = 'MainPath';
const RoomID = 'RoomID';
const PAGE_PATH = './chat_active.html';
const port = process.env.PORT || 5000;
//-----------------------------------Messages------------------------------------//
const ERROR = 'Hi, how can i help..';
const RUNNING = 'Server is starting....';
const PORT_LISTEN = 'Listening to port : ';
//-----------------------------------END--------------------------------------------//
//---------------------------------------------------------------------------------
//---------------------------------Fresh Start--------------------------------------//
//---------------------------------------------------------------------------------
//-----------------------------------Code-------------------------------------------//
const express = require(EXPRESS_LIB);
const app = express();
const server = require(HTTP_LIB).createServer(app);
const io = require(SOCKET_LIB)(server);

app.get(SERVER_NONE, (req, res) => {
    console.log(ERROR);
    res.sendFile(PAGE_PATH, { root: __dirname });
});

io.on(SERVER_CONNECT, socket => {
    chatRoomID = socket.handshake.query.chatID;
    socket.join(chatRoomID);

    socket.on(SERVER_DISCONNECT, () => {
        socket.leave(chatRoomID);
    });
    
    socket.on(SERVER_SEND, message => {
        let path = message.MainPath;
        let iD = message.MessageID;
        let chatID = message.RoomID;
        let sender = message.SenderID;
        let receriver = message.ReceiverID;
        let content = message.Content;
        let date = message.Time;

        // Send to the other one
        socket.in(chatID).emit(SERVER_RECERIVE, {
            Time : date,
            Content : content,
            SenderID : sender,
            ReceiverID : receriver,
            MessageID : iD,
            MainPath : path,
            RoomID : chatID,
        });
    });
});

server.listen(port, () => {
    console.log(RUNNING);
    console.log(PORT_LISTEN + port);
});
//---------------------------------------END SERVER--------------------------------------//