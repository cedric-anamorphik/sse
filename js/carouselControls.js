var targetPositionZ = 0;

var targetRotationX = 0;
var targetRotationOnMouseDownX = 0;

var targetRotationY = 0;
var targetRotationOnMouseDownY = 0;
	
var mouseDown = false;
	
var mouseX = 0;
var mouseXOnMouseDown = 0;

var mouseY = 0;
var mouseYOnMouseDown = 0;

var windowHalfX = 0;
var windowHalfY = 0;

var finalRotationY
var objName = "";
var isRotating = true;
var isCarousel = false;
var isMoving = false;
var dir = "forward";
var targetObj;
var targetNum = 0;

var mouseVector = new THREE.Vector3();
var projector = new THREE.Projector();

//////////////////////////////////////////////////////////////////////////////////
//		ALT ROTATION EVENT LISTENERS 							//
//////////////////////////////////////////////////////////////////////////////////
document.addEventListener( 'mousedown', onDocumentMouseDown, false );
document.addEventListener( 'mousemove', onDocumentMouseMove, false );
document.addEventListener( 'mouseup', onDocumentMouseUp, false );
//document.addEventListener( 'touchstart', onDocumentTouchStart, false );
//document.addEventListener( 'touchmove', onDocumentTouchMove, false );

function setWindowHalf(w,h) {
	var windowHalfX = w / 2; //window.innerWidth / 2;
	var windowHalfY = h / 2; //window.innerHeight / 2;
}

function update() {
	
	if (( targetRotationX - targetObj.rotation.y ) < .005 && objName != "uranus" && isRotating && ( targetPositionZ - containerPlanets.position.z ) < .005 ){
  		targetRotationX+=.005;
	}
	
	if ( objName == "earth" ){
		earthCloud.rotation.y += .0008;
	} else if ( objName == "jupiter" ){
		jupiterCloud.rotation.y += .002;
	}
  
	//horizontal rotation  
	targetObj.rotation.y += ( targetRotationX - targetObj.rotation.y ) * 0.1;
	 
	//vertical rotation
	finalRotationY = (targetRotationY - targetObj.rotation.x);
	  
	//     targetObj.rotation.x += finalRotationY * 0.05;
	//     finalRotationY = (targetRotationY - targetObj.rotation.x);
	  
    if (targetObj.rotation.x  <= 1 && targetObj.rotation.x >= -1 ) {
    	targetObj.rotation.x += finalRotationY * 0.1;
    }
    
    if (targetObj.rotation.x  > 1 ) {
    	targetObj.rotation.x = 1
    }
    
    if (targetObj.rotation.x  < -1 ) {
    	targetObj.rotation.x = -1
    }
	
	// add the container z position as another tweenable param in the customControls
	if ( isCarousel ){
		containerPlanets.position.z += ( targetPositionZ - containerPlanets.position.z ) * 0.1;
	}
	
}

function onDocumentMouseUp( event ) {
 	console.log("up");
 	
 	//mouseVector.x = 2 * (event.clientX / width) - 1;
	//mouseVector.y = 1 - 2 * ( event.clientY / height );
	//	
	//var raycaster = projector.pickingRay( mouseVector.clone(), camera ),
	//	intersects = raycaster.intersectObjects( containerPlanets.children );
	//	
	//console.log("intersectCount = "+intersects.length);
 	
	document.removeEventListener( 'mouseout', onDocumentMouseOut, false );
	mouseDown = false;
	isMoving = false;
	
}

function doStepBack(){
	// even though we're stepping back, we're still moving forward though space...
	if (targetPositionZ < 22.5){
		
		targetPositionZ	+= +2.5;
		targetNum += 1;
		targetObj = planets[targetNum][0];
		objName = planets[targetNum][1];
		targetRotationY = targetObj.rotation.x;
		targetRotationX = targetObj.rotation.y;
		
	}
}

function doStepForward(){
	// even though we're stepping back, we're still moving forward though space...
	if (targetPositionZ > 0){
		
		targetPositionZ	-= 2.5;
		targetNum -= 1;
		targetObj = planets[targetNum][0];
		objName = planets[targetNum][1];
		targetRotationY = targetObj.rotation.x;
		targetRotationX = targetObj.rotation.y;
		
	}
}

function onDocumentMouseOut( event ) {
	console.log("out");
    //document.removeEventListener( 'mousemove', onDocumentMouseMove, false );
    //document.removeEventListener( 'mouseup', onDocumentMouseUp, false );
    document.removeEventListener( 'mouseout', onDocumentMouseOut, false );
	mouseDown = false;
	isMoving = false;
}

function onDocumentMouseDown( event ) {
	console.log("down");
	// raycasting may have set color to something other than default;
	// set all back to default;
	//containerPlot.children.forEach(function( containerPlot ) {
		//containerPlot.material.color.set( 0xCCCCCC );
	//});
	
	mouseDown = true;
	
	event.preventDefault();
	
	//document.addEventListener( 'mousemove', onDocumentMouseMove, false );
	//document.addEventListener( 'mouseup', onDocumentMouseUp, false );
	document.addEventListener( 'mouseout', onDocumentMouseOut, false );
	
	mouseXOnMouseDown = event.clientX - windowHalfX;
	targetRotationOnMouseDownX = targetRotationX;
	
	mouseYOnMouseDown = event.clientY - windowHalfY;
	targetRotationOnMouseDownY = targetRotationY;
	
}
	
function onDocumentMouseMove( event ) {
	console.log("move");
	if ( mouseDown ){
		
	    mouseX = event.clientX - windowHalfX;
	    mouseY = event.clientY - windowHalfY;
		
		if ( (mouseY - mouseYOnMouseDown) >= 4 || (mouseX - mouseXOnMouseDown) >= 4 ){
			isMoving = true;
		}
		
		if ( isMoving ){
			targetRotationY = targetRotationOnMouseDownY + (mouseY - mouseYOnMouseDown) * 0.01;
			targetRotationX = targetRotationOnMouseDownX + (mouseX - mouseXOnMouseDown) * 0.01;
		}
		
	}
}

