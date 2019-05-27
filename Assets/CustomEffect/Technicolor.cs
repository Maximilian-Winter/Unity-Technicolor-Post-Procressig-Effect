using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(TechnicolorRenderer), PostProcessEvent.AfterStack, "Custom/Technicolor")]
public sealed class Technicolor : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Technicolor effect intensity.")]
    public FloatParameter techniAmount = new FloatParameter { value = 0.5f };

    [Range(0f, 128f), Tooltip("Technicolor power.")]
    public IntParameter techniPower = new IntParameter { value = 0 };

    [Range(0f, 1f), Tooltip("Technicolor red negative intensity.")]
    public FloatParameter redNegativeAmount = new FloatParameter { value = 0.5f };

    [Range(0f, 1f), Tooltip("Technicolor green negative intensity.")]
    public FloatParameter greenNegativeAmount = new FloatParameter { value = 0.5f };

    [Range(0f, 1f), Tooltip("Technicolor blue negative intensity.")]
    public FloatParameter blueNegativeAmount = new FloatParameter { value = 0.5f };
}

public sealed class TechnicolorRenderer : PostProcessEffectRenderer<Technicolor>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Technicolor"));
        sheet.properties.SetFloat("_techniAmount", settings.techniAmount);
        sheet.properties.SetFloat("_techniPower", settings.techniPower);
        sheet.properties.SetFloat("_redNegativeAmount", settings.redNegativeAmount);
        sheet.properties.SetFloat("_greenNegativeAmount", settings.greenNegativeAmount);
        sheet.properties.SetFloat("_blueNegativeAmount", settings.blueNegativeAmount);

        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}