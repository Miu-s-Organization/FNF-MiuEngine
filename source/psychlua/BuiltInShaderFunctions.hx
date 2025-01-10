package psychlua;

#if (!flash && sys)
import shaders.Shaders;
#end

class BuiltInShaderFunctions
{
	public static function implement(funk:FunkinLua)
	{
		var lua = funk.lua;
		//SHADER SHIT
		if (ClientPrefs.data.shaders) {
			Lua_helper.add_callback(lua, "addChromaticAbberationEffect", function(camera:String, chromeOffset:Float = 0.005) {
				PlayState.instance.addShaderToCamera(camera, new ChromaticAberrationEffect(chromeOffset));
			});
			Lua_helper.add_callback(lua, "addScanlineEffect", function(camera:String, lockAlpha:Bool = false) {
				PlayState.instance.addShaderToCamera(camera, new ScanlineEffect(lockAlpha));
			});
			Lua_helper.add_callback(lua, "addGrainEffect", function(camera:String, grainSize:Float, lumAmount:Float, lockAlpha:Bool = false) {
				PlayState.instance.addShaderToCamera(camera, new GrainEffect(grainSize,lumAmount,lockAlpha));
			});
			Lua_helper.add_callback(lua, "addTiltshiftEffect", function(camera:String, blurAmount:Float, center:Float) {
				PlayState.instance.addShaderToCamera(camera, new TiltshiftEffect(blurAmount,center));
			});
			Lua_helper.add_callback(lua, "addVCREffect", function(camera:String, glitchFactor:Float = 0.0, distortion:Bool = true, perspectiveOn:Bool = true, vignetteMoving:Bool = true) {
				PlayState.instance.addShaderToCamera(camera, new VCRDistortionEffect(glitchFactor,distortion,perspectiveOn,vignetteMoving));
			});
			
			// shader clear
			Lua_helper.add_callback(lua, "clearShadersFromCamera", function(cameraName) {
				LuaUtils.cameraFromString(cameraName).filters = [];
			});	

			Lua_helper.add_callback(lua, "addWiggleEffect", function(camera:String, effectType:String, waveSpeed:Float = 0.1, waveFrq:Float = 0.1, waveAmp:Float = 0.1, ?verticalStrength:Float = 1, ?horizontalStrength:Float = 1) {
				PlayState.instance.addShaderToCamera(camera, new WiggleEffectLua(effectType, waveSpeed, waveFrq, waveAmp, verticalStrength, horizontalStrength));
			});	
			Lua_helper.add_callback(lua, "addGlitchEffect", function(camera:String, waveSpeed:Float = 0.1, waveFrq:Float = 0.1, waveAmp:Float = 0.1) {	
				PlayState.instance.addShaderToCamera(camera, new GlitchEffect(waveSpeed, waveFrq, waveAmp));
			});
			Lua_helper.add_callback(lua, "addGlitchShader", function(camera:String, waveAmp:Float = 0.1, waveFrq:Float = 0.1, waveSpeed:Float = 0.1) {
				PlayState.instance.addShaderToCamera(camera, new GlitchEffect(waveSpeed, waveFrq, waveAmp));
			});
			Lua_helper.add_callback(lua, "addPulseEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {
				PlayState.instance.addShaderToCamera(camera, new PulseEffect(waveSpeed,waveFrq,waveAmp));
			});
			Lua_helper.add_callback(lua, "addDistortionEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {
				PlayState.instance.addShaderToCamera(camera, new DistortBGEffect(waveSpeed,waveFrq,waveAmp));
			});
			Lua_helper.add_callback(lua, "addInvertEffect", function(camera:String,lockAlpha:Bool=false) {
				PlayState.instance.addShaderToCamera(camera, new InvertColorsEffect(lockAlpha));
			});
			Lua_helper.add_callback(lua, "addGreyscaleEffect", function(camera:String) { //for dem funkies
				PlayState.instance.addShaderToCamera(camera, new GreyscaleEffect());
			});
			Lua_helper.add_callback(lua, "addGrayscaleEffect", function(camera:String) { //for dem funkies
				PlayState.instance.addShaderToCamera(camera, new GreyscaleEffect());
			});
			Lua_helper.add_callback(lua, "add3DEffect", function(camera:String,xrotation:Float=0,yrotation:Float=0,zrotation:Float=0,depth:Float=0) { //for dem funkies
				PlayState.instance.addShaderToCamera(camera, new ThreeDEffect(xrotation,yrotation,zrotation,depth));
			});
			Lua_helper.add_callback(lua, "addBloomEffect", function(camera:String,intensity:Float = 0.35,blurSize:Float=1.0) {
				PlayState.instance.addShaderToCamera(camera, new BloomEffect(blurSize/512.0,intensity));
			});
			Lua_helper.add_callback(lua, "addBlockedGlitchEffect", function(camera:String, res:Float = 1280, time:Float = 1, colorMult:Float = 1, colorTransform:Bool = true) {	
				if (colorTransform) PlayState.instance.addShaderToCamera(camera, new BlockedGlitchEffect(res, time, colorMult, colorTransform));
			});
			Lua_helper.add_callback(lua, "clearEffects", function(camera:String) {
				PlayState.instance.clearShaderFromCamera(camera);
			});
		}
	}
}