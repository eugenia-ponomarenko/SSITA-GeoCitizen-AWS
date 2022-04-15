module "module_lb" {
	source               	= "./module_1"
}
  
module "module_asg" {
	source               	= "./module_2"
}
