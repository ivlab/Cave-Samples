using UnityEngine;

namespace IVLab.MinVR3.VRPN.Samples
{
    /// <summary>
    /// Simple script to set the position/orientation of a Unity object based on some float data
    /// </summary>
    public class AnalogDemo : MonoBehaviour
    {
        public VREventCallbackFloat analogEvent;

        void Start()
        {
            analogEvent.AddRuntimeListener(a => 
            {
                var v = this.transform.position;
                v.y = a;
                this.transform.position = v;
            });

            analogEvent.StartListening();
        }
    }
}