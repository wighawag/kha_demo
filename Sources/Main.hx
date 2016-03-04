package;

import kha.System;
import kha.Assets;
import demo.Model;
import demo.Presenter;

class Main {
	public static function main() {
		System.init("kha_demo", 1024, 768, function () {
			Assets.loadEverything(function(){
				var model = new Model();
				var presenter = new Presenter(model);
				new Project(model, presenter);	
			});
		});
	}
}
