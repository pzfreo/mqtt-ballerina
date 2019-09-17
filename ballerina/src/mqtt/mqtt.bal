import ballerinax/java;
import ballerinax/java.arrays as jarrays;

function newMQTTClient(handle broker, handle clientId) returns handle|error = @java:Constructor {
    paramTypes: ["java.lang.String", "java.lang.String"],
    class: "org.eclipse.paho.client.mqttv3.MqttClient"
} external;

function newCallbackObject() returns handle = @java:Constructor {
    class: "freo.me.ballerinamqtt.BallerinaCallback"
} external;

function wrapByte(byte b) returns handle = @java:Constructor {
    class: "java.lang.Byte",
    paramTypes: ["byte"]
} external;

public function mqttconnect(handle cl) returns error? = @java:Method {
    name:"connect",
    paramTypes: [],
    class: "org/eclipse/paho/client/mqttv3/MqttClient"
} external;

public function mqttsubscribe(handle cbo, Callback cb, handle cl, handle topicFilter) returns error? = @java:Method {
    name: "subscribe",
    class: "freo/me/ballerinamqtt/BallerinaCallback"
} external;

public function mqttdisconnect(handle cl) returns error? = @java:Method {
    name:"disconnect",
    paramTypes: [],
    class: "org/eclipse/paho/client/mqttv3/MqttClient"
} external;

public function mqttpublish(handle cl, handle topic, handle payload, int qos, boolean retained) returns error? = @java:Method {
    name:"publish",
    paramTypes: ["java.lang.String", {class:"byte", dimensions:1}, "int", "boolean"], 
    class: "org/eclipse/paho/client/mqttv3/MqttClient"
} external;


public type Message record {
    string topic;
    byte[] payload;
};

public type Callback abstract object {
    public function onMessage(Message m); 
};

public type Client client object {
    handle mqttClient;
    
    public function __init(string broker, string clientId) returns error? {
        handle brokerString = java:fromString(broker);
        handle clientString = java:fromString(clientId);
        self.mqttClient = check newMQTTClient(brokerString, clientString);
    }
    public remote function connect() returns error? {
        check mqttconnect(self.mqttClient);
    }

    public remote function disconnect() returns error? {
        check mqttdisconnect(self.mqttClient);
    }

    public remote function publish(Message message, int qos, boolean retained) returns error? {
        handle topicString = java:fromString(message.topic);
        handle payloadBytes = jarrays:newInstance(check java:getClass("byte"), message.payload.length());
        
        int count=0;
        while (count < message.payload.length()) {
            jarrays:set(payloadBytes, count, wrapByte(message.payload[count]));
            count+=1;    
        }
        check mqttpublish(self.mqttClient, topicString, payloadBytes, qos, retained);
    }

    public remote function subscribe(string topicFilter, Callback cb) returns error? {
        handle cbo = newCallbackObject();
        handle topicFilterString = java:fromString(topicFilter);
        check mqttsubscribe(cbo, cb, self.mqttClient,  topicFilterString); 
    }
};

