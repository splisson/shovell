,hijaxRelatedGeo:function(){if($(this.relatedGeoLinkId)){this.relatedGeoLinkObj=$(this.relatedGeoLinkId);this.relatedGeoLinkObj.addEvent('click',function(e){e.preventDefault();Citysearch.Popup.fireNewPopup(this,{'width':300,'titleText':this.get('text')});});this.relatedGeoLinkObj.addClass('popupLink');}},hijaxToDoLink:function(){if($(this.toDoLinkId)){this.toDoLinkObj=$(this.toDoLinkId);this.toDoLinkObj.addEvent('click',function(e){e.preventDefault();Citysearch.Popup.fireNewPopup(this,{'width':300,'titleText':Citysearch.Text.Main.footerToDo});});this.toDoLinkObj.addClass('popupLink');}},hijaxServiceLink:function(){if($(this.serviceLinkId)){this.serviceLinkObj=$(this.serviceLinkId);this.serviceLinkObj.addEvent('click',function(e){e.preventDefault();Citysearch.Popup.fireNewPopup(this,{'width':300,'titleText':Citysearch.Text.Main.footerServices});});this.serviceLinkObj.addClass('popupLink');}},hijaxMoreInfoLink:function(){if($(this.moreInfoLinkId)){this.moreInfoLinkObj=$(this.moreInfoLinkId);this.moreInfoLinkObj.addEvent('click',function(e){e.preventDefault();Citysearch.Popup.fireNewPopup(this,{'width':300,'titleText':Citysearch.Text.Main.footerMoreInfo});});this.moreInfoLinkObj.addClass('popupLink');}},hijaxContactLink:function(){if($(this.contactLinkId)){this.contactLinkObj=$(this.contactLinkId);this.contactLinkObj.addEvent('click',function(e){e.preventDefault();Citysearch.Popup.fireNewPopup(this,{'width':300,'titleText':Citysearch.Text.Main.footerContact});});this.contactLinkObj.addClass('popupLink');}}};

Citysearch.Facebook={config:{apiKey:'',callbackUrl:'',membersHref:'',
facebookTitle:''},
init:function(){
    if(Citysearch.logging>=5){console.info("INFO: Facebook.init");} 
    if(window.FB_RequireFeatures&&(typeof window.FB_RequireFeatures==="function")){
        if(Citysearch.TempConfig&&Citysearch.TempConfig.Facebook){
            this.config=Citysearch.TempConfig.Facebook;
            Citysearch.TempConfig.Facebook=null;
            FB.Bootstrap.init(Citysearch.Facebook.config.apiKey,Citysearch.Facebook.config.callbackUrl);
            FB.Bootstrap.ensureInit(function(){
                                        FB.FBDebug.isEnabled=false;
                                        FB.FBDebug.logLevel=0;});
        }
    }
},
login:function(){
    FB.Bootstrap.ensureInit(function(){
        FB.Connect.requireSession();
        if(!FB.Facebook.get_sessionWaitable().result){
            FB.Facebook.get_sessionWaitable().add_changed(Citysearch.Facebook.checkSessionState);
        } else {
            Citysearch.Facebook.returnFrom();
        }
    });
},
checkSessionState:function() {
    var sessionWaitable=FB.Facebook.get_sessionWaitable();
    if(sessionWaitable.get_isReady()&&sessionWaitable.result){
        Citysearch.Facebook.returnFrom();
    }
},
returnFrom:function(){
    Cookie.write('reload','1',{'domain':Citysearch.baseDomain,'duration':0,'path':'/'});
    Citysearch.ModalWindow.closeObj.addEvent('click',function(){window.location=window.location;});
    var facebookReturn=new Request({'url':Citysearch.Facebook.config.membersHref,'method':'get','evalScripts':true}).send();
}

};


Citysearch.AjaxInit={objectName:"",
activeRequest:new Request(),config:{},overlayDiv:new
Element('div'),spinningDiv:new Element('div'),cancelButton:new
Element('span'),run:function(){if(Citysearch.AjaxInit.objectName!==""){
var initObject=Citysearch;var
initSequence=Citysearch.AjaxInit.objectName.split('.');for(var
i=0;i<initSequence.length;i++){initObject=initObject[initSequence[i]];if
(!initObject){return;}}
