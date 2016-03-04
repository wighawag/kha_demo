package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

import demo.Model;
import demo.Presenter;

class Project {
	var lastModelTime : Float;
	var lastRenderTime : Float;
	var model : Model;
	var presenter : Presenter;
	
	public function new(model : Model, presenter : Presenter) {
		lastModelTime = 0;
		lastRenderTime = 0;
		this.presenter = presenter;
		this.model = model;
		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update(): Void {
		var now = Scheduler.time();
		var delta = now - lastModelTime;
		lastModelTime = now;
		model.update(now,delta);
	}

	function render(framebuffer: Framebuffer): Void {
		var now = Scheduler.time();
		var delta = now - lastRenderTime;
		lastRenderTime = now;
		presenter.render(now, framebuffer);		
	}
}
