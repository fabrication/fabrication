/**
 * Copyright (C) 2008 Darshan Sawardekar.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.patterns.observer.Notifier;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.NotificationInterests;
	import org.puremvc.as3.multicore.utilities.fabrication.vo.Reaction;	

	/**
	 * FabricationMediator is the base mediator class for all application mediator
	 * classes. This class should be subclassed for providing environment
	 * specific operations.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationMediator extends Mediator implements IDisposable {

		/**
		 * The handler name prefix used to reflect the notification interests 
		 * of a fabrication mediator. Any methods with this prefix are
		 * interpreted as a notification interest. The default prefix is respondTo 
		 */
		static public var DEFAULT_NOTIFICATION_HANDLER_PREFIX:String = "respondTo";

		/**
		 * The handler name prefix used to reflect reactions in the event bubbling or target
		 * phase. Methods with this prefix are interpreted as reactions. The default prefix
		 * is reactTo
		 */
		static public var DEFAULT_REACTION_PREFIX:String = "reactTo";

		/**
		 * The handler name prefix used to reflect reaction in the capture phase. Methods with
		 * this prefix are interpreted as reactions. The default prefix is capture.
		 */
		static public var DEFAULT_CAPTURE_PREFIX:String = "trap";

		/**
		 * Regular expression used to match notification interest in a specific proxy name
		 */ 
		static public var proxyNameRegExp:RegExp = new RegExp(".*Proxy.*", "");

		/**
		 * Regular expression used to check if a notification is qualified
		 */
		static public var notePartRegExp:RegExp = new RegExp("\/", "");

		/**
		 * Regular expression used for case conversion
		 */
		static public var firstCharRegExp:RegExp = new RegExp("^(.)", "");

		/**
		 * Key used to store cached notification with the facade. 
		 */
		static public var notificationCacheKey:String = "notificationCache";

		/**
		 * Stores list of qualified notifications. Notifications should be
		 * qualified if there are multiple notifications with the same
		 * sub part name.
		 */
		protected var qualifiedNotifications:Object;

		/**
		 * Default notification handle prefix within this mediator. Default
		 * is respondTo.  
		 */
		protected var notificationHandlerPrefix:String = DEFAULT_NOTIFICATION_HANDLER_PREFIX;

		/**
		 * Default bubbling or at target phase reaction prefix within this mediator.
		 * Default is reactTo. 
		 */
		protected var reactionHandlerPrefix:String = DEFAULT_REACTION_PREFIX;

		/**
		 * Default capture phase reaction prefix within this mediator.
		 */
		protected var captureHandlerPrefix:String = DEFAULT_CAPTURE_PREFIX;

		/**
		 * Reference to the facade instance specified notification cache object.
		 */
		protected var notificationCache:HashMap;

		/**
		 * The reaction object currently active in this mediator.
		 */
		protected var currentReactions:Array;

		/**
		 * Creates a new FabricationMediator object.
		 */
		public function FabricationMediator(name:String = null, viewComponent:Object = null) {
			super(name, viewComponent);
		}

		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			qualifiedNotifications = null;
			notificationCache = null;
			
			if (currentReactions != null) {
				var n:int = currentReactions.length;
				var reaction:Reaction; 
				for (var i:int = 0;i < n; i++) {
					reaction = currentReactions[i];
					reaction.dispose();
				}
				
				currentReactions = null;
			}
		}

		/**
		 * Returns a reference to the fabrication facade.
		 */
		public function get fabFacade():FabricationFacade {
			return facade as FabricationFacade;
		}

		/**
		 * Returns a reference to the current application 
		 * fabrication instance.
		 */
		public function get fabrication():IFabrication {
			return fabFacade.getFabrication();
		}

		/**
		 * Returns a reference to the current application's message
		 * router.
		 */
		public function get applicationRouter():IRouter {
			return fabrication.router;
		}

		/**
		 * Returns the current application's module address.
		 */
		public function get applicationAddress():IModuleAddress {
			return fabrication.moduleAddress;
		}

		/**
		 * Alias to facade.retrieveProxy
		 * 
		 */
		public function retrieveProxy( proxyName:String ):IProxy {
			return facade.retrieveProxy(proxyName);	
		}

		/**
		 * Alias to facade.hasProxy
		 */
		public function hasProxy( proxyName:String ):Boolean {
			return facade.hasProxy(proxyName);
		}

		/**
		 * Alias to facade.registerMediator
		 * 
		 * @return The mediator being registered
		 */
		public function registerMediator( mediator:IMediator ):IMediator {
			facade.registerMediator(mediator);
			return mediator;
		}

		/**
		 * Alias to facade.retrieveMediator
		 */
		public function retrieveMediator( mediatorName:String ):IMediator {
			return facade.retrieveMediator(mediatorName) as IMediator;
		}

		/**
		 * Alias to facade.removeMediator
		 */
		public function removeMediator( mediatorName:String ):IMediator {
			return facade.removeMediator(mediatorName);
		}

		/**
		 * Alias to facade.hasMediator
		 */
		public function hasMediator( mediatorName:String ):Boolean {
			return facade.hasMediator(mediatorName);
		}

		/**
		 * Alias to facade.routeNotification
		 * 
		 * @see org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade#routeNotification()
		 */
		public function routeNotification(noteName:Object, noteBody:Object = null, noteType:String = null, to:Object = null):void {
			fabFacade.routeNotification(noteName, noteBody, noteType, to);
		}

		/**
		 * Overrides the initializeNotifier to initialize local references to the notification
		 * cache and route mapper.
		 */
		override public function initializeNotifier(key:String):void {
			super.initializeNotifier(key);

			initializeNotificationCache();
		}

		/**
		 * Creates a local reference to the notification cache object for the current facade 
		 */
		protected function initializeNotificationCache():void {
			if (!fabFacade.hasInstance(notificationCacheKey)) { 
				notificationCache = fabFacade.saveInstance(notificationCacheKey, new HashMap()) as HashMap;
			} else {
				notificationCache = fabFacade.findInstance(notificationCacheKey) as HashMap;
			}
		}

		/**
		 * Calculates the notification interests of the current mediator
		 * using reflection. The fabrication's getClassByName is used
		 * to workaround the sandboxing of getDefinitionByName.
		 * 
		 * <p>
		 * The notification interests are cached after reflection. Any
		 * subsequent calls to listNotificationInterests returns the
		 * cached notifications interests.
		 * </p>
		 * 
		 * <p>
		 * If interest in a specific proxy is expressed via respondTo[ProxyName]
		 * a system notification NOTIFICATION_FROM_PROXY is used to 
		 * listen to a notification from a proxy. This will only
		 * work if the proxy extends FabricationProxy
		 * </p>
		 */
		override public function listNotificationInterests():Array {
			var qpath:String = getQualifiedClassName(this);
			var notificationInterests:NotificationInterests = notificationCache.find(qpath) as NotificationInterests;
			if (notificationInterests != null) {
				qualifiedNotifications = notificationInterests.qualifications;
				
				return notificationInterests.interests;
			}
			
			var interests:Array = new Array();
			var classpath:String = qpath.replace("::", ".");

			try {			
				var clazz:Class = fabrication.getClassByName(classpath);
			} catch (e:Error) {
				throw new Error("Unable to perform reflection for classpath " + classpath + ". Check if getClassByName is defined on the main fabrication class");
			}
			
			var clazzInfo:XML = describeType(clazz);
			
			var methodNameRe:RegExp = new RegExp("^" + notificationHandlerPrefix + "(.*)$", ""); 
			var respondToMethods:XMLList = clazzInfo..method.((methodNameRe as RegExp).exec(@name) != null);
			var respondToMethodsCount:int = respondToMethods.length();
			var proxyNameRegExpMatch:Object;
			var methodNameReMatch:Object;
			var hasProxyInterests:Boolean = false;
			var methodXML:XML;
			var methodName:String;
			var noteName:String;
			
			qualifiedNotifications = qualifyNotificationInterests();
			if (qualifiedNotifications == null) {
				qualifiedNotifications = new Object();
			}
			
			for (var i:int = 0;i < respondToMethodsCount; i++) {
				methodXML = respondToMethods[i];
				methodName = methodXML.@name;
				proxyNameRegExpMatch = proxyNameRegExp.exec(methodName);
								
				if (!hasProxyInterests && proxyNameRegExpMatch != null) {
					hasProxyInterests = true;
				} else if (proxyNameRegExpMatch == null) {
					methodNameReMatch = methodNameRe.exec(methodName);
					if (methodNameReMatch != null) {
						noteName = methodNameReMatch[1];
						noteName = lcfirst(noteName);
						
						if (isNotificationQualified(noteName)) {
							noteName = getNotificationQualification(noteName) + "/" + noteName;
						}
						
						interests.push(noteName);
					}
				}
			}
			
			if (hasProxyInterests) {
				interests.push(FabricationProxy.NOTIFICATION_FROM_PROXY);
			}			
			
			respondToMethods = null;
			clazzInfo = null;
			
			notificationCache.put(qpath, new NotificationInterests(qpath, interests, qualifiedNotifications));
			
			return interests;
		}

		/**
		 * Handles the PureMVC notification and invokes the reflected method
		 * that corresponds to the notification. If the notification was
		 * qualified then the notification name is prefixed with it. For
		 * a NOTIFICATION_FROM_PROXY interest the notification is  
		 */
		override public function handleNotification(note:INotification):void {
			var noteName:String = note.getName();
			var noteParts:Array;
			var notePrefix:String;
			var plainNote:String;
			
			if (noteName == FabricationProxy.NOTIFICATION_FROM_PROXY) {
				var payloadNotification:INotification = note.getBody() as INotification;
				var payloadNoteName:String = payloadNotification.getName();
				
				if (notePartRegExp.test(payloadNotification.getName())) {
					noteParts = payloadNoteName.split("/");
					
					notePrefix = noteParts[0]; 
					plainNote = noteParts[1];
					
					notePrefix = ucfirst(notePrefix);
					invokeNotificationHandler(notificationHandlerPrefix + notePrefix, payloadNotification);
				} else {
					notePrefix = note.getType();
					notePrefix = ucfirst(notePrefix);
					invokeNotificationHandler(notificationHandlerPrefix + notePrefix, payloadNotification);
				}
			} else {
				if (notePartRegExp.test(noteName)) {
					noteParts = noteName.split("/");
					notePrefix = noteParts[0]; 
					plainNote = noteParts[1];
					
					var noteQualification:String = getNotificationQualification(plainNote);
					
					// a qualified notification is only reflected if it was
					// explicitly qualified by the subclass 
					if (noteQualification != null && noteQualification == notePrefix) {
						plainNote = ucfirst(plainNote);
						invokeNotificationHandler(notificationHandlerPrefix + plainNote, note);
					}
				} else {
					noteName = ucfirst(noteName);
					invokeNotificationHandler(notificationHandlerPrefix + noteName, note);
				}
			}
		}

		/**
		 * Returns the qualified notification prefixes if any. Default
		 * is null which indicates no prefixes. Subclasse can qualify
		 * a notification with hashmap like,
		 * 
		 * <listing>
		 * 	var interests:Object = new Object();
		 * 	interests["Change"] = "SampleProxy"
		 * 	
		 * 	return interests
		 * </listing>
		 * 
		 * This is interpreted as the notification name "SampleProxy/Change".
		 * You only need to qualify notifications if the part name is the
		 * same for multiple notifications and you are using reflection.
		 */
		public function qualifyNotificationInterests():Object {
			return null;
		}

		/**
		 * Returns true if the notification name is qualified with a prefix.
		 * 
		 * @param noteName The name of the notification to test.
		 */
		public function isNotificationQualified(noteName:String):Boolean {
			return getNotificationQualification(noteName) != null;
		}

		/**
		 * Returns the prefix for the notification name specified if qualified.
		 * 
		 * @param noteName The name of the notification whose prefix is to be retrieved.
		 */
		public function getNotificationQualification(noteName:String):String {
			return qualifiedNotifications[noteName];
		}

		/**
		 * Creates the reactions for the current mediator using reflection.
		 */
		public function initializeReactions():void {
			var reactionPattern:String = "(" + reactionHandlerPrefix + "|" + captureHandlerPrefix + ")";
			var reactionRegExp:RegExp = new RegExp("^" + reactionPattern + ".*$", "");
			var qpath:String = getQualifiedClassName(this);
			var classpath:String = qpath.replace("::", ".");

			try {			
				var clazz:Class = fabrication.getClassByName(classpath);
			} catch (e:Error) {
				//throw e;
				throw new Error("Unable to perform reflection for classpath " + classpath + ". Check if getClassByName is defined on the main fabrication class");
			}
			
			var clazzInfo:XML = describeType(clazz);
			
			var reactionMethods:XMLList = clazzInfo..method.((reactionRegExp as RegExp).test(@name) == true);
			var reactionMethodsCount:int = reactionMethods.length();
			
			if (reactionMethodsCount == 0) {
				// early exit if no reactions were found
				reactionMethods = null;
				clazzInfo = null;
				return;
			}
			
			var accessorRegExp:RegExp = new RegExp("(::FabricationMediator$|::Mediator$|Class$)", "");
			var accessorMethods:XMLList = clazzInfo..accessor.((accessorRegExp as RegExp).test(@declaredBy) == false);
			var accessorMethodsCount:int = accessorMethods.length();
			
			var eventType:String;
			var eventSourceName:String;
			var eventSource:IEventDispatcher;
			var handlerName:String;
			var eventHandler:Function;
			var eventPhase:String;
			var useCapture:Boolean;
			
			var extractRegExp:RegExp;
			var patternList:Array = new Array();
			var matchResult:Object;
			var i:int = 0;
			var j:int = 0;
			var reaction:Reaction;
			
			currentReactions = new Array();
			
			for (i = 0;i < accessorMethodsCount; i++) {
				handlerName = accessorMethods[i].@name;
				extractRegExp = new RegExp("^" + reactionPattern + "(" + ucfirst(handlerName) + ")" + "(.*)$", "");
				patternList.push(extractRegExp);
			}
			
			for (i = 0;i < reactionMethodsCount; i++) {
				handlerName = reactionMethods[i].@name;
				for (j = 0;j < accessorMethodsCount; j++) {
					extractRegExp = patternList[j];
					matchResult = extractRegExp.exec(handlerName);
					if (matchResult != null) {
						eventPhase = matchResult[1];
						eventSourceName = matchResult[2];
						eventSource = this[lcfirst(eventSourceName)];
						eventType = lcfirst(matchResult[3]);
						eventHandler = this[handlerName];
						useCapture = eventPhase == captureHandlerPrefix;
						
						reaction = new Reaction(eventSource, eventType, eventHandler, useCapture);
						currentReactions.push(reaction);
						
						reaction.start();
					}
				}
			}
			
			accessorMethods = null;
			reactionMethods = null;
			accessorRegExp = null;
			reactionRegExp = null;
			clazzInfo = null;			
		}
		
		/**
		 * Stops the specified reaction.
		 * 
		 * @param handler The name of the handler function or a reference to it.
		 */
		public function haltReaction(handler:Object):void {
			actOnReaction(handler, "stop");
		}
		
		/**
		 * Resumes the reaction if it hasn't already started. 
		 * 
		 * @param handler The name of the handler function or a reference to it.
		 */
		public function resumeReaction(handler:Object):void {
			actOnReaction(handler, "start");
		}
		
		/**
		 * Disposes the reaction and removes it from the current list of reactions.
		 * 
		 * @param handler The name of the handler function or a reference to it.
		 */
		public function removeReaction(handler:Object):void {
			actOnReaction(handler, "dispose");
		}
		
		/**
		 * Removes the specified reaction.
		 * 
		 * @param handler The name of the handlerfunction or a reference to it.
		 * @param action The name of the method to invoke on the reaction.
		 */
		public function actOnReaction(handler:Object, action:String):void {
			if (handler is String) {
				handler = this[handler];
			}
			
			var n:int = currentReactions.length;
			var reaction:Reaction;
			for (var i:int = 0; i < n; i++) {
				reaction = currentReactions[i];
				if (reaction.handler == handler) {
					reaction[action]();
					if (action == "dispose") {
						currentReactions.splice(i, 1);
					}
					break;
				}
			}
		}
		
		/**
		 * Initializes the reactions in this mediator. Subclasses that override this method must
		 * call super.onRegister for reactions to work.
		 */
		override public function onRegister():void {
			// This condition check allows the tests with mock mediators to work without
			// additional mocks that are needed to support reactions 
			if (multitonKey != null) {
				initializeReactions();
			}
		}

		/**
		 * Helper function to invoke the notification handler if it exists.
		 */
		protected function invokeNotificationHandler(name:String, note:INotification):void {
			if (this.hasOwnProperty(name)) {
				this[name](note);
			}
		}

		/**
		 * Utility to convert the first character of the string to uppercase.
		 * @private
		 */
		private function ucfirst(body:String):String {
			var result:Object = body.match(firstCharRegExp);
			return body.replace(firstCharRegExp, result[1].toUpperCase());
			//return body.substring(0, 1).toUpperCase() + body.substring(1); 
		}

		/**
		 * Utility to convert the first character of the string to lowercase.
		 * @private
		 */
		private function lcfirst(body:String):String {
			var result:Object = body.match(firstCharRegExp);
			return body.replace(firstCharRegExp, result[1].toLowerCase());
			//return body.substring(0, 1).toLowerCase() + body.substring(1);
		}
	}
}
