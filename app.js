const express = require('express');
const app = express();
const port = 6644;
const http = require('http');
const request = require('request');


var list_ip = ['localhost:4567'];
var list_ip_blockchain = ['localhost:6644'];
var len = 0;

app.get('/new/tx', function (req, res) {
    console.log("\n############### TRANSACTION ###############");
    console.log("Received a new transaction...");
    res.send('OK');
    var response = {
        s: req.query.s,
        r: req.query.r,
        a: req.query.a
        };
    console.log("Received transaction is : Sender = " + response['s'] + " receiver = " + response['r'] + " with amount = " + response['a']);
    for (var ips in list_ip) {
        var url = list_ip[ips] + "/new/tx?s=" + response['s'] + "&r=" + response['r'] + "&a=" + response['a'];
        console.log("Beginning to send to all peers...");
        process.stdout.write(`Sending transaction to ${list_ip[ips]}...     `);

        request('http://' + url, function (error, response, body) {
           console.log("DONE.")
        });
    }
});

app.get('/get/bclength', function (req, res) {
    console.log("\n############### BLOCKCHAIN ###############");
    res.send('OK');
    var response = {
        len: req.query.len
    };
    len = response.len;
    console.log("Received a new 'length' ping... Length is " + len);
    console.log("Broadcasting actual length...");
    for (var ips in list_ip) {
        //La, il faut remplacer l'adresse par IPS
        request('http://localhost:6644/test/bc?len='+len, function (error, response, body) {
            if(body == "true"){
                console.log('Found client that have less blocks than actual...');
                //La, il faut remplacer l'adresse par IPS
                request('http://localhost:4567/blockchain', function (error, response, body) {
                  console.log("Sent information for download.")
                });
            }
        });
    }
});

app.get('/test/bc', function (req, res) {
    var response = {
        len: req.query.len
    };
    if(40 > len){
        res.send(true);
    } else {
        res.send(false)
    }
});

app.get('/new/bc', function(req, res) {
    console.log("A client is downloading the blockchain...");
    res.download('./test.db');
   console.log("Downloading complete.")
}) ;


app.listen(port, () => console.log('Broadcast server launched...'));
