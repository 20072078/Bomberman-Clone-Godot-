extends Particles2D

func _ready():
	set_process(true)
	self.one_shot = true
	
	

func _process(_delta):
	self.emitting = true
