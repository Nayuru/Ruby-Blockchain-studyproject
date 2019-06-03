const express = require('express');
const app = express();
const port = 6644;
const http = require('http');
const request = require('request');

//Liste des IP de tous les peers
var list_ip = ['localhost'];
//Port de l'API Ruby
var r_port = ":4567";
//Port de l'API Node
var n_port = ":6644";
//Longueur de la blockchain initialisée à 0
var len = 0;
//var list_ip_blockchain = ['localhost:6644'];

//On écoute à l'adresse /new/tx, qui permettra de partager à notre réseau la création d'une transaction
app.get('/new/tx', function (req, res) {
    console.log("test2");
    console.log("\n############### TRANSACTION ###############");
    console.log("Received a new transaction...");
    res.send('OK');
    //On récupère les paramètres de la requête
    var response = {
        s: req.query.s, //s pour sender, celui qui va effectuer la transaction
        r: req.query.r, //r pour receiver, celui qui va recevoir la transaction
        a: req.query.a // a pour amount, le montant de la transaction
        };
    console.log("Received transaction is : Sender = " + response['s'] + " receiver = " + response['r'] + " with amount = " + response['a']);

    //On envoie la nouvelle transaction à chaque peer un par un
    for (var ips in list_ip) {
        var url = list_ip[ips] + r_port + "/new/tx?s=" + response['s'] + "&r=" + response['r'] + "&a=" + response['a'];
        console.log("Beginning to send to all peers...");
        process.stdout.write(`Sending transaction to ${list_ip[ips] + r_port}...     `);

        request('http://' + url, function (error, response, body) {
           console.log("DONE.")
        });
    }
});

//On écoute à l'adresse /get/bclength, ce qui nous permettra de recevoir la longueur de notre blockchain et de comparer avec celle que l'on a actuellement
app.get('/get/bclength', function (req, res) {
    console.log("test1");
    console.log("\n############### BLOCKCHAIN ###############");
    res.send('OK');
    //On récupère la longueur dans les paramètres de la requête
    var response = {
        len: req.query.len
    };
    //On actualise len qui est la variable représentant la taille de la blockchain
    len = response.len;
    console.log("Received a new 'length' ping... Length is " + len);
    console.log("Broadcasting actual length...");
    for (var ips in list_ip) {
        request("http://" + list_ip[ips] + n_port + '/test/bc?len='+len, function (error, response, body) {
            console.log(list_ip[ips] + n_port + '/test/bc?len='+len);
            console.log(body);
            if(body === "true"){
                console.log('Found client that have less blocks than actual...');
                request("http://" + list_ip[ips] + r_port + '/blockchain', function (error, response, body) {
                  console.log("Sent information for download.")
                });
            }
        });
    }
});

//On comparera ici la longueur de notre blockchain locale avec celle que l'on reçoit en paramètre
app.get('/test/bc', function (req, res) {
    var response = {
        len: req.query.len
    };
    if(parseInt(response.len, 10) > len){
        res.send(true);
    } else {
        res.send(false)
    }
});

//On fait télécharger la blockchain à celui qui nous la demande
app.get('/new/bc', function(req, res) {
    console.log("A client is downloading the blockchain...");
    res.download('./test.db');
   console.log("Downloading complete.")
}) ;


app.listen(port, () => console.log('Broadcast server launched...'));
