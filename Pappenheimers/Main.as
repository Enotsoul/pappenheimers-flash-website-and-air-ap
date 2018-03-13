package
{
	import Pappenheimers_fla.Spelers_6;
	import Pappenheimers_fla.Spelregels_3;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.PerspectiveProjection;
	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.formats.FormatValue;
	
	import lost.utils.SettingsLoader;
	import lost.utils.Validator;
	import lost.utils.xml.XMLLoader;
	
	public class Main extends MovieClip
	{
		private var settings:SettingsLoader;
		private var conn:NetConnection;
		private var contentPage:MovieClip;
		private var spelRegels:PageSpelRegels = new PageSpelRegels;
		private var personArray:Array = [];
		private var questions:Array = [];
		
		private var textBox:TextField = new TextField();
		
		//	private var pageSpelers:
		
		public function Main()
		{
			//Load the settings...
			settings =  SettingsLoader.getInstance();
			settings.addEventListener(XMLLoader.XML_LOADED,settingsLoadedHandler)
			settings.load("assets/settings.xml")
		
			//Security.allowDomain("s.ytimg.com");
			addChild(textBox);
			//init
			contentPage = new MovieClip();
			addChild(contentPage);
			contentPage.y = 125;
			contentPage.x = 3
				//add startpage
			contentPage.addChild(new StartPage());
				
			buttons()
			//contentPage.
			//menu. = true
			
	
		}
		private function buttons():void {
			menu.addEventListener(MouseEvent.CLICK,menuClickHandler)
			spelRegels.spelregelsmenu.addEventListener(MouseEvent.CLICK,menuClickHandler)
		}
	
	/* 
	** Functions
	*/
		//textbox
		private function showTextBox(text:String):void {
			textBox.visible= true
			var loadingFormat:TextFormat = new TextFormat();
			
			loadingFormat.font = "Tahoma";
			loadingFormat.size = 30;
			
			textBox.text = text
			textBox.setTextFormat(loadingFormat);
			textBox.autoSize = TextFieldAutoSize.CENTER;
			//textBox.width = 200;
			//textBox.height = 300;
			textBox.x = (stage.width-textBox.width)/2;
			textBox.y = (stage.height-textBox.height)/2;
			textBox.addEventListener(MouseEvent.CLICK,function() { textBox.visible = false });
		}
		
		private function cleanPage():void {
			try {
				while (contentPage.numChildren > 0) {
					contentPage.removeChildAt(0);
				}
			} catch (error:Error) {
				trace("Couldn't remove a child..");
			}
		}
		private function rand(min:int, max:int):int {
			return min + (max - min) * Math.random();
		}
		private function moveWindow(window:Object):void {
			var rand:int = rand(1,5);
			switch (rand) {
				case 1:
					TweenLite.to(window,1.5,{x:stage.width, y:stage.height,alpha:1});  // to right
					break;
				case 2:
					//TweenLite.to(window,1.5,{x:stage.width, y:-stage.height,alpha:1}); 
					break;
				case 3:
					TweenLite.to(window,1.5,{x:-stage.width, y:stage.height,alpha:1});  // to left
					break;
				case 4:
				//	TweenLite.to(window,1.5,{x:-stage.width, y:-stage.height,alpha:1}); 
					break;
			}
			trace("case  " + rand)
		}
		
		//youtube stuff video loading
		private var _loader:Loader;
		private var _player:Object;
		
		public function youtubeVideo(videoStr:String):void { 
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _onLoaderInit, false, 0, true);
			_loader.load(new URLRequest("http://www.youtube.com/v/" +videoStr + "?version=3"))
		}
		
		private function _onLoaderInit(event:Event):void {
			_player = _loader.content; 
			_player.addEventListener("onReady", _onPlayerReady, false, 0, true);
			contentPage.addChild(DisplayObject(_player));
			
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, _onLoaderInit);
			_loader = null;
		}
		
		private function _onPlayerReady(event : Event) : void {
			_player.removeEventListener("onReady", _onPlayerReady);
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.  
			_player.setSize(640, 360);
		}

	/* 
	** Events
	*/
		private function menuClickHandler(event:MouseEvent) {
			var menuButton:String = 	event.target.name
			var newChild:MovieClip;
			var showHere:Boolean = true;
			trace(menuButton);
			//moveWindow(contentPage.getChildAt(0))
	
			switch (menuButton) {
				case 'start':
					cleanPage();
					newChild = new StartPage();
					contentPage.addChild(newChild)
					break;
				case 'kandideren':
					cleanPage();
					newChild = new PageKandideren()
					newChild.ikWilKandideren.addEventListener(MouseEvent.CLICK,formKandideren);
					contentPage.addChild(newChild)
					break;
				case 'spelregels':
					cleanPage();
					newChild = spelRegels;
					contentPage.addChild(newChild)
					break;
				case 'suggesties':
				
					showQuestions()
		
					showHere = false;
					break;
				case 'online':
					cleanPage();
					//allow youtube.. to the security list
			
					Security.allowDomain('www.youtube.com');
					Security.allowDomain('youtube.com');
					Security.allowDomain('s.ytimg.com');
					Security.allowDomain('i.ytimg.com');

					newChild = new MovieClip();
					//load from database maybe..?
					youtubeVideo("bt3im8cLWnI")
				
					break;
				case 'spelers':
					showPersons()
					showHere = false;
					break;
				case 'androidapp':
					//cleanPage();
					showHere= false;
					/*var request:URLRequest = new URLRequest("assets/pappenheimers.air.apk");
					navigateToURL(request);*/
					var request:URLRequest = new URLRequest(settings.androidLink);
					var localRef:FileReference = new FileReference();
					try	{
						// Prompt and downlod file
						localRef.download(request);
					}
					catch (error:Error){			
						trace("Unable to download file.");
					}
					break;
				// spelregels menu
				case 'kennismakingsronde':
					trace("Kennis ronde.. pff")
					spelRegels.textBox.text = settings.kennismaking
					//spelRegels.scrollbar.drawNow()
					spelRegels.scrollbar.update()
					newChild = spelRegels;
					break;
				case 'verdeelenheers':
					newChild = spelRegels;
					spelRegels.textBox.text = settings.verdeelenheers
					spelRegels.scrollbar.update()
					break;
				case 'gevenennemen':
					newChild = spelRegels;
					spelRegels.textBox.text = settings.gevenennemen
					spelRegels.scrollbar.update()
					break;
				case 'finale':
					newChild = spelRegels;
					spelRegels.textBox.text = settings.finale
					spelRegels.scrollbar.update()
					break;
			}
			if(showHere) { showPage(newChild) }
		}
		
		//kandideren form
		private function formKandideren(event:Event):void {
			var insertResponder:Responder = new Responder(insertPersonResultHandler,faultHandler);
			var data:Object = new Object();
			var errorString:String = ""
			data.name1 = event.currentTarget.parent.naam1.text;
			data.address1 = event.currentTarget.parent.adres1.text;
			data.age1 = event.currentTarget.parent.leeftijd1.text;
			
			data.name2 = event.currentTarget.parent.naam2.text;
			data.address2 = event.currentTarget.parent.adres2.text;
			data.age2 = event.currentTarget.parent.leeftijd2.text;
			
			trace(data.age2);
			
			var errors:Boolean = true;
			//geen lege velden, lengte velden, geen standardwaarden
			//if (Validator.validateEmail(sendLove.toEmailField.text) && Validator.validateEmail(sendLove.fromEmailField.text)) { trace("Emails must be valid") ; errors= false; }
			if (data.name1 == "" || data.name2 == "" || data.age1 == "" || data.age2 == "" 
			|| data.address1 == "" || data.address2 == "" ) { errorString += "Vul alle velden in!\n" ; errors= false; }
			if (Validator.validateAge(int(data.age1)) || Validator.validateAge(int(data.age2))) { errorString += "Uw leeftijden moeten nummers boven 18 jaar zijn.\n" ; errors = false; }
		
			if (errors == true) {
				trace("Ok send it!");
				event.currentTarget.parent.errors.text  = ""
				conn.call("pappenheimers.insertPersons",insertResponder,data);
			} else { trace("Error while validating!"); event.currentTarget.parent.errors.text = errorString }
	
		
		}
		//toevoegen form
		private function formToevoegenSuggestie(event:Event):void {
			var insertResponder:Responder = new Responder(insertSuggestieResultHandler,faultHandler);
			var data:Object = new Object();
			var errorString:String = ""
			data.question = event.currentTarget.parent.vraag.text;
			data.goodanswer = event.currentTarget.parent.juist.text;
			data.badanswer1 = event.currentTarget.parent.slecht1.text;
			data.badanswer2 = event.currentTarget.parent.slecht2.text;
				
			var errors:Boolean = true;
			//geen lege velden, lengte velden, geen standardwaarden
			//if (Validator.validateEmail(sendLove.toEmailField.text) && Validator.validateEmail(sendLove.fromEmailField.text)) { trace("Emails must be valid") ; errors= false; }
			if (data.question == "" || data.goodanswer == "" || data.badanswer1 == "" 
				|| data.badanswer2 == "" ) { errorString += "Vul alle velden in!\n" ; errors= false; }
				
			if (errors == true) {
				trace("Ok send it!");
				event.currentTarget.parent.errors.text  = ""
				conn.call("pappenheimers.insertQuestion",insertResponder,data);
			} else { trace("Error while validating!"); event.currentTarget.parent.errors.text = errorString }
			
			
		}
		private function showPersons():void {
			//make the result responder
			var resultResponder:Responder = new Responder(getPersons,faultHandler);
			//get scores from database
			try {
				conn.call("pappenheimers.getPersons",resultResponder);
			} catch (error:Error)  { showTextBox("There was a problem with the database..") }		
		}
		private function getPersons(object:Object):void {
			cleanPage();
			trace("success in gettting persons:)");
			var resultaat:Array = object.serverInfo.initialData;
			var personsPage:PageSpelers = new PageSpelers;
			
			contentPage.addChild(personsPage);
			personsPage.spelerslijst.text = ""
			
			for each(var item:Array in resultaat) {		
				
				var temp:Person = new Person(item[0], item[1], item[2], item[3]);
				personArray.push(temp);
				trace(temp.name)
				personsPage.spelerslijst.text += (temp.name  + " is " + temp.age + " jaar oud en woont in " + temp.address  + "\n")
				
			}
			showPage(personsPage)
			
		}
		private function showQuestions():void {
			//make the result responder
			var resultResponder:Responder = new Responder(getQuestions,faultHandler);
			//get scores from database
			try {
			conn.call("pappenheimers.getQuestions",resultResponder);
			} catch (error:Error)  { showTextBox("There was a problem with the database..") }
		}
		private function getQuestions(object:Object):void {
			trace("success in gettting questions:)");
			
			var resultaat:Array = object.serverInfo.initialData;
			cleanPage();
			var	newChild:MovieClip = new PageSuggesties;
			newChild.toevoegen.addEventListener(MouseEvent.CLICK,formToevoegenSuggestie);
			contentPage.addChild(newChild)
			
			newChild.questions.text = ""
			
			for each(var item:Array in resultaat) {		
				var temp:Question = new Question(item[0], item[1], item[2], item[3],item[4]);
				questions.push(temp);
				newChild.questions.text += ("(" + temp.id + "): " + temp.question + "\n")
			}
		}
		
		private function getPersonNr():void {
			//make the result responder
			var resultResponder:Responder = new Responder(getAllPersonNr,faultHandler);
			//get scores from database
			conn.call("pappenheimers.getTotalPersons",resultResponder);
			
		}
		private function getAllPersonNr(object:Object):void {
			cleanPage();
			trace("success in gettting persons:)");
			var resultaat:Array = object.serverInfo.initialData;
			trace(resultaat);
				
		}
		
		private function showPage(window:Object):void {
			window.alpha = 0.0;
			TweenLite.to(window,1.5,{alpha:1});  
		}
		private function settingsLoadedHandler(event:Event):void {
			trace("ROOT: " + settings.server);
			
			try {
			//Initialise connection
			conn = new NetConnection()
			//connect to the gateway
		
				conn.connect(settings.server);
				trace("Connection should have succeeded..");
			} catch (error:Error) {
				showTextBox("Connection failed, please open webserver or change the settings!");
			}
			spelRegels.textBox.text = settings.kennismaking
		}
		//Success handler
		private function insertPersonResultHandler(result:Object):void {
			if(result) {
				trace("yeeepiee inserted")
				showPersons()
			}else {
				trace("not inserted:(")
			}
		}
		private function insertSuggestieResultHandler(result:Object):void {
			if(result) {
				trace("yeeepiee inserted")
				//reload suggestions page
				showQuestions()
			}else {
				trace("not inserted:(")
			}
		}
		//Something went horribly wrong!
		private function faultHandler(event:Object):void {
			trace("An Error Occured " + event );
		}
	}
}