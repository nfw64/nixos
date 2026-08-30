import QtQuick
import Quickshell.Services.Notifications

QtObject {
  id: notificationData

  property Notification notification: null
  property bool closed: false

  property string seqId: ""
  property string notifId: notification ? String(notification.id) : ""

  // Use direct property bindings instead of manual assignment
  readonly property string summary: notification ? (notification.summary || "") : ""
  readonly property string body: notification ? (notification.body || "") : ""
  readonly property string appIcon: notification ? (notification.appIcon || "") : ""
  readonly property string appName: notification ? (notification.appName || "") : ""
  readonly property string image: notification ? (notification.image || "") : ""
  readonly property int urgency: notification ? notification.urgency : NotificationUrgency.Normal
  readonly property real expireTimeout: {
    if (!notification) return defaultTimeout;
    return notification.expireTimeout > 0 ? notification.expireTimeout : defaultTimeout;
  }

  readonly property var actions: {
    if (!notification || !notification.actions) return [];
    return notification.actions.map(function(a) {
        return { identifier: a.identifier, text: a.text };
    });
  }

  property bool hovered: false
  readonly property int defaultTimeout: 5000

  readonly property Connections _conn: Connections {
    target: notificationData.notification

    function onClosed(): void {
      if (notificationData.closed) return;
      notificationData.closed = true;
      NotificationService._remove(notificationData);
      notificationData.destroy();
    }
  }

  readonly property Timer _timer: Timer {
    running: !notificationData.closed
    && !notificationData.hovered
    && notificationData.urgency !== NotificationUrgency.Critical
    interval: notificationData.expireTimeout
    onTriggered: {
      notificationData.dismiss()
    }
  }

  function resetTimer(): void {
    if (_timer.running) {
      _timer.restart();
    }
  }

  function dismiss(): void {
    if (closed) return;
    closed = true;
    NotificationService._remove(notificationData);
    if (notification) try { notification.dismiss(); } catch(e) {}
    destroy();
  }

  function invokeAction(identifier): void {
    if (!identifier || closed) return;
    closed = true;
    NotificationService._remove(notificationData);
    if (notification) {
      const action = notification.actions.find(function(a) {
          return a.identifier === identifier;
      });
      if (action) try { action.invoke(); } catch(e) {}
    }
    destroy();
  }
}
