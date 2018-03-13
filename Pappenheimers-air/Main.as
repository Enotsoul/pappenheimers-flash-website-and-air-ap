package
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import lost.utils.SettingsLoader;
	import lost.utils.xml.XMLLoader;
	
	public class Main extends MovieClip
	{
		
		private var settings:SettingsLoader;
		private var conn:NetConnection;
		private var contentPage:MovieClip = new MovieClip();
		private var questions:Array = [];
		private var textBox:TextField = new TextField();
		
		private var score:int = 0;
		private var totalQuestions:int = 10;
		private var questionsLeft:int;
		private var startQuiz:StartQuiz = new StartQuiz()
		private var menu:Menu = new Menu();
		private var overState:OverState = new OverState();
		
		//private var startQuiz:MyButt
		public function Main()
		{
			addChild(textBox);
			showTextBox("Loading questions from database...");
		//Load the settings...
		settings =  SettingsLoader.getInstance();
		settings.addEventListener(XMLLoader.XML_LOADED,settingsLoadedHandler)
		settings.load("assets/settings.xml")
		//init
		contentPage = new MovieClip();
		addChild(contentPage);
		contentPage.y = 150;
		contentPage.x = 3
			
		contentPage.addChild(startQuiz)
		startQuiz.visible = false
		startQuiz.x = (stage.width-startQuiz.width)/2;
		startQuiz.y = (stage.height-startQuiz.height)/3;
		startQuiz.addEventListener(MouseEvent.CLICK,startQuizHandler);
		
		}
		//textbox
		private function showTextBox(text:String):void {
			var loadingFormat:TextFormat = new TextFormat();
			
			loadingFormat.font = "Tahoma";
			loadingFormat.size = 23;
			
			textBox.text = text
			textBox.setTextFormat(loadingFormat);
			textBox.autoSize = TextFieldAutoSize.CENTER;
			//textBox.width = 200;
			//textBox.height = 300;
			textBox.x = (stage.width-textBox.width)/4;
			textBox.y = (stage.height-textBox.height)/4;
		}
		//do quizz stuff & count right or wrong answers
				
		private function genQuestion():void {
			var q:int = rand(0,questions.length)
			trace(questions.length)
		
	 var question:Question = questions[q];
	
			//add menu
			menu = new Menu();
			contentPage.addChild(menu)
			menu.x = (stage.width-menu.width)/2;
			menu.y = (stage.height-menu.height)/5;
			
			//set texts
			menu.question.text = question.question;
			// Switch place of answers each time!
 
			var a= rand(1,4);
			try {
				if (a ==1) {
						menu.answer1.buttonName.text = question.goodanswer
						menu.answer2.buttonName.text = question.badanswer1
						menu.answer3.buttonName.text = question.badanswer2
						setTimeout(function () {
							menu.answer1.addEventListener(MouseEvent.CLICK,goodAnswer);
							menu.answer2.addEventListener(MouseEvent.CLICK,badAnswer);
							menu.answer3.addEventListener(MouseEvent.CLICK,badAnswer);
						},300);
					} else if(a==2) {
						menu.answer3.buttonName.text = question.badanswer1
						menu.answer1.buttonName.text = question.badanswer2
						menu.answer2.buttonName.text = question.goodanswer
						setTimeout(function () {
							menu.answer3.addEventListener(MouseEvent.CLICK,badAnswer);
							menu.answer1.addEventListener(MouseEvent.CLICK,badAnswer);
							menu.answer2.addEventListener(MouseEvent.CLICK,goodAnswer);
						},300);
					} else if (a==3) {
						menu.answer1.buttonName.text = question.badanswer1
						menu.answer2.buttonName.text = question.badanswer2
						menu.answer3.buttonName.text = question.goodanswer
						setTimeout(function () {
							menu.answer1.addEventListener(MouseEvent.CLICK,badAnswer);
							menu.answer2.addEventListener(MouseEvent.CLICK,badAnswer);
							menu.answer3.addEventListener(MouseEvent.CLICK,goodAnswer);
						},300);
					}
					
			//	randomButtonAssignment(question,a)
			} catch (error:Error) { trace("tick tack toe problem..") }
			
			menu.answer1.buttonName.autoSize = TextFieldAutoSize.CENTER;
			menu.answer2.buttonName.autoSize = TextFieldAutoSize.CENTER;
			menu.answer3.buttonName.autoSize = TextFieldAutoSize.CENTER;
			
			menu.answer1.buttonMode = true
			menu.answer2.buttonMode = true
			menu.answer3.buttonMode = true
		
		}
		private function randomButtonAssignment(question:Question,a:int) {
						
			if (a ==1) {
				menu.answer1.buttonName.text = question.goodanswer
				menu.answer2.buttonName.text = question.badanswer1
				menu.answer3.buttonName.text = question.badanswer2
					
				menu.answer1.addEventListener(MouseEvent.CLICK,goodAnswer);
				menu.answer2.addEventListener(MouseEvent.CLICK,badAnswer);
				menu.answer3.addEventListener(MouseEvent.CLICK,badAnswer);
			} else if(a==2) {
				menu.answer3.buttonName.text = question.badanswer1
				menu.answer1.buttonName.text = question.badanswer2
				menu.answer2.buttonName.text = question.goodanswer
					
				menu.answer3.addEventListener(MouseEvent.CLICK,badAnswer);
				menu.answer1.addEventListener(MouseEvent.CLICK,badAnswer);
				menu.answer2.addEventListener(MouseEvent.CLICK,goodAnswer);
			} else if (a==3) {
				menu.answer1.buttonName.text = question.badanswer1
				menu.answer2.buttonName.text = question.badanswer2
				menu.answer3.buttonName.text = question.goodanswer
					
				menu.answer1.addEventListener(MouseEvent.CLICK,badAnswer);
				menu.answer2.addEventListener(MouseEvent.CLICK,badAnswer);
				menu.answer3.addEventListener(MouseEvent.CLICK,goodAnswer);
			}
		}
		
		/* 
		** Functions
		*/
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
	
		/* 
		** Events
		*/
		private function startQuizHandler(event:MouseEvent) {
			startQuiz.visible = false;
			questionsLeft = totalQuestions;
			genQuestion();
		}
		private function goodAnswer(event:MouseEvent) {
			contentPage.removeChild(menu)
			score += 1;
			questionsLeft -= 1;
			addChild(overState);
			if (questionsLeft == 0) {
				overState.info.text = "Einde van quiz.\n Uw score is: " + score + "/" + totalQuestions
			} else {
				overState.info.text = "Juist!"
			}
			setTimeout(function() { overState.addEventListener(MouseEvent.CLICK,removeOverState) }, 300);
		}
		private function badAnswer(event:MouseEvent) {
			contentPage.removeChild(menu)
			questionsLeft -= 1;
			addChild(overState);

			if (questionsLeft == 0) {
				overState.info.text = "Einde van quiz.\n Uw score is: " + score + "/" + totalQuestions
			} else {
				overState.info.text = "Fout!:("
			}
			setTimeout(function() { overState.addEventListener(MouseEvent.CLICK,removeOverState) }, 300);
		}
		private function removeOverState(event:MouseEvent) {
			try {
				removeChild(overState) 
			} catch (error:Error) {
				trace("A lil error!");
			}
			if (questionsLeft > 0) { 
				genQuestion() 
			} else {
				startQuiz.visible = true;
				score = 0;
			}
		}
		private function menuClickHandler(event:MouseEvent) {
			var menuButton:String = 	event.target.name
			var showHere:Boolean = true;
			trace(menuButton);
			//moveWindow(contentPage.getChildAt(0))
			
			switch (menuButton) {
				case 'start':
					cleanPage();
					contentPage.addChild(new MovieClip)
					break;
				case 'androidapp':
					//cleanPage();
					showHere= false;
		
					break;
			}
			if(showHere) { showPage(new MovieClip) }
		}

		private function showQuestions():void {
			//make the result responder
			var resultResponder:Responder = new Responder(getQuestions,faultHandler);
			//get scores from database
			conn.call("pappenheimers.getQuestions",resultResponder);
			
		}
		private function getQuestions(object:Object):void {
			trace("success in gettting questions:)");
			
			var resultaat:Array = object.serverInfo.initialData;
			//add it to the array
			for each(var item:Array in resultaat) {		
				var temp:Question = new Question(item[0], item[1], item[2], item[3],item[4]);
				questions.push(temp);
			}
			//remove the loading thing when done
			removeChild(textBox);
			startQuiz.visible = true;
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
				//connect to database, get questions.. put them in array
				showQuestions();
			} catch (error:Error) {
				showTextBox("Connection failed, please open webserver or change the settings!");
			}
		}

		//Something went horribly wrong!
		private function faultHandler(event:Object):void {
			trace("An Error Occured " + event );
		}
	}
}