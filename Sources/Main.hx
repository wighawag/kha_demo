package;

import kha.System;
import kha.Assets;
import demo.Model;
import demo.Presenter;

class Main {
	public static function main() {
		System.init({title:"kha_demo", width : 1024, height : 768}, function () {
			Assets.loadEverything(function(){
				var model = new Model();
				var presenter = new Presenter(model);
				new Project(model, presenter);	
			});
		});
	}
}
