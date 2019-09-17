package freo.me.ballerinamqtt;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import org.ballerinalang.jvm.BRuntime;
import org.ballerinalang.jvm.BallerinaValues;
import org.ballerinalang.jvm.scheduling.Scheduler;
import org.ballerinalang.jvm.scheduling.Strand;
import org.ballerinalang.jvm.types.AttachedFunction;
import org.ballerinalang.jvm.types.BPackage;
import org.ballerinalang.jvm.values.ArrayValue;
import org.ballerinalang.jvm.values.MapValue;
import org.ballerinalang.jvm.values.ObjectValue;
import org.eclipse.paho.client.mqttv3.IMqttMessageListener;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

public class BallerinaCallback implements IMqttMessageListener {
    public static final BPackage MQTT_PACKAGE_ID = new BPackage("pzfreo", "mqtt", "0.3.1");
    private ObjectValue callback = null;
    private BRuntime runtime = null;
    private MqttClient client = null;
    

    public void subscribe(ObjectValue callback, MqttClient mqttClient, String topicFilter) throws MqttException {
        this.callback = callback;
        this.client = mqttClient;
        this.runtime = BRuntime.getCurrentRuntime();
        mqttClient.subscribe(topicFilter, this);
        return;
    }

    public void messageArrived(String topic, MqttMessage message) {
        try {
        
            MapValue msgObj = BallerinaValues.createRecordValue(MQTT_PACKAGE_ID, "Message");
            ArrayValue av = new ArrayValue(message.getPayload());
            msgObj.put("topic", topic);
            msgObj.put("payload", av);
            runtime.invokeMethodSync(this.callback, "onMessage", msgObj, true);
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }
}