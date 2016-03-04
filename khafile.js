var project = new Project('kha_demo');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addShaders('Sources/Shaders/**');
project.addLibrary('spriter');
project.addLibrary('spriterkha');
project.addLibrary('imagesheet');
return project;
