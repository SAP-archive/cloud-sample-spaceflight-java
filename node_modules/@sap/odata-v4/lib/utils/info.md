# Performance monitor

The performance monitor is able to measure time and heap space usage.
You can create childs on each monitor instance which will create a monitor tree
from the top root monitor to the latest monitor at the bottom of the tree.

# Usage

```js
const PerformanceMonitorFactory = require('/lib/utils/PerformanceMonitor').PerformanceMonitorFactory;

// Create the root monitor instance
const isActive = true;
const monitor = PerformanceMonitorFactory.getInstance(isActive);

// Sets a starting time to the root monitor
monitor.start();

setTimeout(() => {
    // Stops the root monitor
    monitor.stop();
}, 1000);

// Create a child monitor and start it on the fly.
const childMonitor = monitor.createChild('A child monitor').start();

// Create another child monitor from an existing child.

const child = childMonitor.createChild('A child of a child');

// Selecting any child with a path.
const aChildMonitor = monitor.getChild('A child monitor');
const aChildOfAChildMonitor = monitor.getChild('A child monitor/A child of a child');
const aChildMonitor2 = aChildMonitor.getChild('A child of a child');

// Getting the result of a monitor.
const result = monitor.getResult();

```
