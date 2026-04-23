using UnityEngine;

namespace IVLab.MinVR3.VRPN.Samples
{
    /// <summary>
    /// Simple script to set the position/orientation of a Unity object based on some float data
    /// </summary>
    public class ButtonDemo : MonoBehaviour
    {
        public VREventCallbackInt buttonEvent;

        void Start()
        {
            Transform buttonObject = this.transform.Find("Button");
            float startY = buttonObject.transform.position.y;
            float activeY = startY - 0.1f;
            buttonEvent.AddRuntimeListener(s => 
            {
                var v = buttonObject.transform.position;
                if (s == 0)
                    v.y = startY;
                else if (s == 1)
                    v.y = activeY;
                buttonObject.transform.position = v;
            });

            buttonEvent.StartListening();
        }
    }
}