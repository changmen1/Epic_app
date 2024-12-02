package com.example.your_app

import android.app.Service
import android.content.Intent
import android.os.IBinder
import org.eclipse.paho.client.mqttv3.*
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence
import android.app.NotificationManager
import android.app.NotificationChannel
import android.app.Notification
import android.os.Build
import androidx.core.app.NotificationCompat

class MQTTService : Service() {
    private var mqttClient: MqttClient? = null
    private val NOTIFICATION_CHANNEL_ID = "mqtt_service_channel"

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(1, createNotification())
        connectMQTT()
    }

    private fun connectMQTT() {
        try {
            val serverUri = "ws://192.168.204.189:8083/mqtt"
            val clientId = "android_service_${System.currentTimeMillis()}"

            mqttClient = MqttClient(serverUri, clientId, MemoryPersistence())

            val options = MqttConnectOptions().apply {
                userName = "david_mqtt"
                password = "668877".toCharArray()
                isCleanSession = true
                connectionTimeout = 60
                keepAliveInterval = 60
            }

            mqttClient?.connect(options)

            // 订阅主题
            subscribeToTopics()

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun subscribeToTopics() {
        mqttClient?.setCallback(object : MqttCallback {
            override fun connectionLost(cause: Throwable?) {
                // 重连逻辑
                connectMQTT()
            }

            override fun messageArrived(topic: String?, message: MqttMessage?) {
                message?.let {
                    val payload = String(it.payload)
                    showNotification(topic ?: "未知主题", payload)
                }
            }

            override fun deliveryComplete(token: IMqttDeliveryToken?) {
                // 消息发送完成回调
            }
        })

        // 订阅所有需要的主题
        val topics = arrayOf(
            "MPX0-alarm",
            "MPX1-alarm",
            "DAVID_YP-90-alarm",
            "DAVID_YP-91-alarm",
            "yp-3100-alarm",
            "yp-3101-alarm"
        )

        topics.forEach { topic ->
            mqttClient?.subscribe(topic, 1)
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "MQTT Service",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "MQTT Service Channel"
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("戴维医疗")
            .setContentText("监控服务运行中")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
    }

    private fun showNotification(title: String, message: String) {
        val notificationManager = getSystemService(NotificationManager::class.java)
        val notification = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(System.currentTimeMillis().toInt(), notification)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        mqttClient?.disconnect()
        super.onDestroy()
    }
}