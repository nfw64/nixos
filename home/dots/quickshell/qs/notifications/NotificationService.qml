pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  property list<var> notifications: []
  property bool doNotDisturb: false
  readonly property int count: notifications.length
  property int _seqCounter: 0

  Component {
    id: notifDataComp
    NotificationData {}
  }

  NotificationServer {
    id: server
    actionsSupported:     true
    bodySupported:        true
    bodyMarkupSupported:  true
    imageSupported:       true
    keepOnReload:         false

    onNotification: function(notification) {
      if (root.doNotDisturb) return;

      if (!notification.appName && !notification.summary
        && !notification.body && !notification.image) return;

      notification.tracked = true;

      // 1. Check replacesId first (this is what notify-send -r populates)
      const replaceId = notification.replacesId || 0;
      const targetId = notification.id;

      // Find if an existing popup matches either replacesId or the notification object itself
      const existing = root.notifications.find(function(n) {
          if (!n || n.closed) return false;

          // Check if old notification ID matches the incoming replacesId
          const nId = Number(n.notifId);
          return (replaceId > 0 && nId === replaceId)
          || (n.notification && n.notification.id === targetId)
          || n.notification === notification;
      });

      if (existing) {
        // UPDATE IN-PLACE: Swap the notification pointer & reset auto-dismiss timer
        existing.notification = notification;
        existing.resetTimer();

        // Force array re-evaluation so QML views notify changes
        root.notifications = [...root.notifications];
        return;
      }

      // 2. If it's brand new, instantiate a new card
      const data = notifDataComp.createObject(root, {
          notification: notification,
          seqId: String(root._seqCounter++)
      });

      root.notifications = [data, ...root.notifications];

      if (root.notifications.length > 5) {
        const itemToDismiss = root.notifications[root.notifications.length - 1];
        if (itemToDismiss) itemToDismiss.dismiss();
      }
    }
  }

  function _remove(notifData): void {
    root.notifications = root.notifications.filter(function(n) {
        return n !== notifData;
    });
  }

  function dismiss(notifData): void {
    if (notifData) notifData.dismiss();
  }

  function dismissAll(): void {
    const toRemove = [...root.notifications];
    root.notifications = [];
    for (const n of toRemove) {
      if (!n.closed) {
        n.closed = true;
        if (n.notification) try { n.notification.dismiss(); } catch(e) {}
        n.destroy();
      }
    }
  }
}
