package demo;

import kha.Assets;
import spriter.Spriter;
import spriter.EntityInstance;

import kha.input.Mouse;

class Model{
	
	public var characterX : Float;
	public var characterY : Float;
	public var character : EntityInstance;
	
	public var lightX : Float;
	public var lightY : Float;
	public var lightZ : Float;
	
	public function new(){
		characterX = 0;
		characterY = 0;
		
		lightX = 0;
		lightY = 1;
		lightZ = 0.075;
		
		Mouse.get().notify(null,null,mouseMove,null);
		
		var spriter = Spriter.parseScml(Assets.blobs.WonkySkeleton_scml.toString());
		character = spriter.createEntity("WonkySkull");
	}
	
	function mouseMove(x : Int, y : Int, dx : Int, dy : Int){
		lightX = x;
		lightY = y;
		lightZ = 0.075;
	}
	
	public function update(now : Float, delta : Float){
		characterX += 100 * delta;
		character.step(delta);
	}
}