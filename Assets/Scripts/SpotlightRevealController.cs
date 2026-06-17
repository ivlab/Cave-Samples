using UnityEngine;

public class SpotlightRevealController : MonoBehaviour
{
    [Header("References")]
    public Light spotLight;
    public Renderer graffitiRenderer;

    [Header("Optional Controls")]
    public float edgeSoftness = 0.15f;

    private Material graffitiMaterial;

    void Start()
    {
        if (graffitiRenderer == null)
            graffitiRenderer = GetComponent<Renderer>();

        if (graffitiRenderer != null)
            graffitiMaterial = graffitiRenderer.material;
    }

    void LateUpdate()
    {
        if (spotLight == null || graffitiMaterial == null)
            return;

        graffitiMaterial.SetVector("_LightPos", spotLight.transform.position);
        Debug.Log(spotLight.transform.position);
        graffitiMaterial.SetVector("_LightDir", spotLight.transform.forward);

        graffitiMaterial.SetFloat("_SpotAngle", spotLight.spotAngle);
        graffitiMaterial.SetFloat("_Range", spotLight.range);
        graffitiMaterial.SetFloat("_Softness", edgeSoftness);
    }
}