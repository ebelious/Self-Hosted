## Fix Keyboard **[fn]** key  issues

Some Keyboards have issues with the **fn** keys not working as intended in linux, such as apple type keyboards. These settings should help resolve that  issue


*Note: Im not sure if you would need both options or just 1, but id try the first option then the second option*


### Option 1:
Edit this file `sys/module/hid_apple/parameters/fnmode` and set the value to '0'


*Setting /sys/module/hid_apple/parameters/fnmode to 0 on a Linux system with an Apple keyboard disables the special media/brightness keys in the top row, causing them to act as standard function keys (F1, F2, etc.) by default.*

### Option 2:
Set a kernel module configuration
```
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/20_lofree_fn_mode_fix.conf
```
*This command creates or overwrites a configuration file that tells the Linux kernel to load the hid_apple module with the fnmode=2 option. This ensures that the function keys on your Apple or Lofree keyboard behave in a consistent way, prioritizing the standard F1-F12 functionality. This setting will persist across reboots.*
