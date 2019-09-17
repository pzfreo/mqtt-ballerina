# mqtt-ballerina
A Ballerina client for MQTT based on Paho

To build, first 
```
cd java
gradle build
```

Then 
```
cd ballerina
ballerina build -a -c
```

Tested with Java 8 and Ballerina 1.0.0

Here is a simple example client to publish
```
import pzfreo/mqtt;
import ballerina/io;

public function main() returns error? {
    mqtt:Client c = check new("tcp://test.mosquitto.org", "bal-cl");
    check c->connect();
    mqtt:Message m = {
        topic: "/paul",
        payload: "hello".toBytes()
    };
    check c->publish(m, 1, false);
    check c->disconnect();
}
```

And here is a simple client to subscribe
```
import pzfreo/mqtt;
import ballerina/io;
import ballerina/runtime;
import ballerina/lang.'string as str;

public function main() returns error? {
    mqtt:Client c = check new("tcp://localhost", "bal-cl");
    check c->connect();
    Callback cb = new;
    check c->subscribe("/paul", cb);
    runtime:sleep(10000);
    check c->disconnect();
}

public type Callback object {
    public function onMessage(mqtt:Message m)  {
        io:println("received message on topic: "+m.topic);
        io:println("received payload         : "+ checkpanic str:fromBytes(m.payload) );
    }
};
```

That's all so far.