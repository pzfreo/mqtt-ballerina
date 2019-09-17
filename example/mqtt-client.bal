import pzfreo/mqtt;
import ballerina/io;
import ballerina/runtime;
import ballerina/lang.'string as str;

public function main() returns error? {
    mqtt:Client c = check new("tcp://test.mosquitto.org", "bal-cl");
    check c->connect();
    Callback cb = new;
    check c->subscribe("/paul", cb);
    
    mqtt:Message m = {
        topic: "/paul",
        payload: "hello".toBytes()
    };
    check c->publish(m, 1, false);
    runtime:sleep(1000);
    check c->disconnect();
}

public type Callback object {
    public function onMessage(mqtt:Message m)  {
        io:println("received message on topic: "+m.topic);
        io:println("received payload         : "+ checkpanic str:fromBytes(m.payload) );
    }
};