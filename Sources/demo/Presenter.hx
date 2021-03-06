package demo;

import imagesheet.ImageSheet;
import kha.Framebuffer;
import spriterkha.SpriterG4;

import kha.Assets;

import kha.Font;
import kha.Scheduler;
import kha.Image;
import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.graphics4.TextureUnit;
import kha.graphics4.BlendingOperation;

class Presenter{
	var model : Model;
	
	var imageSheet : ImageSheet;
	var normalImage : Image;
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	var mvp:FastMatrix4;
	var lightPosID:ConstantLocation;
	var lightColorID:ConstantLocation;
	var resolutionID:ConstantLocation;
	var ambientColorID:ConstantLocation;
	var falloffID:ConstantLocation;
	var mvpID:ConstantLocation;
	var diffuseTexUnit : TextureUnit;
	var normalTexUnit : TextureUnit;
	
	
	public function new(model : Model){
		this.model = model;
		
		normalImage = Assets.images.skeleton_sheet_n;
		imageSheet = ImageSheet.fromTexturePackerJsonArray(Assets.blobs.skeleton_sheet_json.toString());
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float2);
		structure.add("tex", VertexData.Float2);
		structure.add("angle", VertexData.Float1);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.norm_frag;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha; 
		pipeline.compile();
		
		mvpID = pipeline.getConstantLocation("MVP");
		diffuseTexUnit = pipeline.getTextureUnit("diffuseTex");
		normalTexUnit = pipeline.getTextureUnit("normalTex");
		
		lightPosID = pipeline.getConstantLocation("lightPos");
		lightColorID = pipeline.getConstantLocation("lightColor");
		resolutionID = pipeline.getConstantLocation("resolution");
		ambientColorID = pipeline.getConstantLocation("ambientColor");
		falloffID = pipeline.getConstantLocation("falloff");
		
		vertexBuffer = new VertexBuffer(
			1000,
			structure,
			Usage.DynamicUsage 
		);
		
		indexBuffer = new IndexBuffer(
			1000,
			Usage.DynamicUsage 
		);
		
	}
	
	public function render(now : Float,framebuffer: Framebuffer){
		
		var g = framebuffer.g4;
		g.begin();
		g.clear(Color.fromFloats(0.0, 0.0, 0.0), 1.0);

		g.setPipeline(pipeline);
		
		mvp = FastMatrix4.orthogonalProjection(0, framebuffer.width, framebuffer.height, 0 , 0.0, 100.0);
		g.setMatrix(mvpID, mvp);
		g.setTexture(diffuseTexUnit, imageSheet.image);
		g.setTexture(normalTexUnit, normalImage);
		
		g.setFloat4(ambientColorID,0.4,0.4,0.4,0.4);
		//g.setFloat4(lightColorID,1,1,1,1);
		g.setFloat4(lightColorID,0.4,0.4,0.4,0.4);
		g.setFloat2(resolutionID, framebuffer.width, framebuffer.height);
		g.setFloat3(falloffID,0.1,0.04,0.06);
		//g.setFloat3(falloffID,0,0,0);
		g.setFloat3(lightPosID,model.lightX,model.lightY,model.lightZ);
		
		var vData = vertexBuffer.lock();
		var iData = indexBuffer.lock();
		
		var vertexIndex = 0;
		
		vertexIndex = SpriterG4.writeSpriterWithRotation(vData,0,5,0,2,4,iData,0,vertexIndex,imageSheet,model.character,model.characterX,framebuffer.height - model.characterY, 1, 1, -Math.PI/10);
		
		vertexBuffer.unlock();
		indexBuffer.unlock();

		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		g.drawIndexedVertices();

		g.end();
		
		var g2 = framebuffer.g2;
		g2.begin(false);
		g2.drawLine(0,framebuffer.height,framebuffer.width,framebuffer.height - Math.sin(Math.PI/10) * framebuffer.width,2);
		g2.end();
	}
}