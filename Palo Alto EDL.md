## Palo Alto EDLs 
This is a way to get free EDls that you can add to your Palo Alto
This is a dynamic list of IPs that will be used to block traffic malicious sources

You first need to go to `opendbl.net`
![opendbl](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-10-04%2014-19-02.png)

You will click on the selected listnames to get the URLs. These URL will be added to the `External Dynamic List` objects we will create. (Select only the ones you would likt to use, does not have to be all of them)

## Objects
Navigate to the `Objects` > `External Dynamic Lists`
`(+)Add` a new EDL
![EDL](https://github.com/ebelious/Self-Hosted/blob/main/Images/Screenshot%20from%202024-10-04%2014-28-15.png)

This part is straight forward for the most part. You can keep the destination URL for the EDL with HTTPS if you have a certificate profile to check the SSL, but you can also just use HTTP if this is not possible.
You make a new External Dynamic list for each EDL you want to use.

## Policy

Create a block rule close to the top of Policies list.
You will add the EDLs to the `Source Address` to block incomming connections.
You can also create an outgoing block rule also and add the EDLs to the `Destination Address`.
