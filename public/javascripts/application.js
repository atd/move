// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//Function for over the content information

function showContentInfo(evnt,layer) {
	nameInfo = layer + "-info";
	nameArticle = layer

	//get de element by id
	var layerInfo = document.getElementById(nameInfo);

	//If is the first time that the mouse over pute on, we take the position
	
	layerInfo.style.display = "block";


	var layerArticle = document.getElementById(nameArticle);
	layerArticle.style.zIndex = "0";
}

function hideContentInfo(layer) {
	nameInfo = layer + "-info";
	nameArticle = layer

	var layerInfo = document.getElementById(nameInfo);
	layerInfo.style.display = "none";


	var layerArticle = document.getElementById(nameArticle);
	layerArticle.style.zIndex = "1";
	
}

