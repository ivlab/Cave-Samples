using UnityEngine;

namespace IVLab.MinVR3.VRPN.Samples
{
    /// <summary>
    /// Simple script to set the position/orientation of a Unity object based on some position/rotation data
    /// </summary>
    public class TrackerDemo : MonoBehaviour
    {
        public VREventCallbackVector3 positionEvent;
        public VREventCallbackQuaternion rotationEvent;

        void Start()
        {
            positionEvent.AddRuntimeListener(p => this.transform.position = p);
            rotationEvent.AddRuntimeListener(q => this.transform.rotation = q);

            positionEvent.StartListening();
            rotationEvent.StartListening();
        }
    }
}