# MQTT Client

A simple MQTT client based on [Eclipse Paho](https://www.eclipse.org/paho/clients/java/).

The project is here: [https://github.com/pzfreo/mqtt-ballerina](https://github.com/pzfreo/mqtt-ballerina)

Available under the Apache License.

```
ballerina pull pzfreo/mqtt
```
A couple of simple examples:

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

You can see an example [here](https://github.com/pzfreo/mqtt-ballerina/blob/master/example/mqtt-client.bal)

That's all so far.