/**
 * Copyright (C) 2008 Darshan Sawardekar, 2010 Rafał Szemraj.
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
 *
 */

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator {
    import flash.events.IEventDispatcher;
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;

    import org.puremvc.as3.multicore.interfaces.IMediator;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.mediator.Mediator;
    import org.puremvc.as3.multicore.utilities.fabrication.fabrication_internal;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.DependencyInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
    import org.puremvc.as3.multicore.utilities.fabrication.logging.FabricationLogger;
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
	 * @author Darshan Sawardekar, Rafał Szemraj
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
		 * Regular expression used to detect if the notification string
		 * is in "constant" format
		 */
		static public var constantRegExp:RegExp = new RegExp("^[A-Z]\w*", "");

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
         * Names of injected properites
         */
        protected var injectionFieldsNames:Array;

        /**
         * holds info, if reactions initialization phase have been done
         */
        private var _reactionsRegistrationPhasePassed:Boolean = false;

		/**
		 * Creates a new FabricationMediator object.
		 */
		public function FabricationMediator(name:String = null, viewComponent:Object = null) {
			super(name, viewComponent);
		}

        /**
         * @inheritDoc
         */
		public function dispose():void {

            if (injectionFieldsNames) {
                var injectedFieldsNum:uint = injectionFieldsNames.length;
                for ( i = 0; i < injectedFieldsNum; i++) {

                    var fieldName:String = ""+injectionFieldsNames[i];
                    this[ fieldName ] = null;
                }
                injectionFieldsNames = null;
            }

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
         * Alias to facade.notifiObservers method. Also sends a NOTIFICATION_FROM_PROXY
		 * system notification which can be used by mediators to listen
		 * to a mediators notification using respondToProxyName methods.
		 */
        public function notifyObservers( notification:INotification ):void {
             fabFacade.notifyObservers( notification );

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
			interests = interests.concat( listNotificationsInterestByNamespaces( clazzInfo ) );
            clazzInfo = null;

			notificationCache.put(qpath, new NotificationInterests(qpath, interests, qualifiedNotifications));
			return interests;
		}

        private function listNotificationsInterestByNamespaces(clazzInfo:XML):Array
        {
            var interests:Array = [];
            var methodXML:XML;
            var respondToMethods:XMLList = clazzInfo..method.( @name == 'processNotification' );
            var respondToMethodsCount:uint = respondToMethods.length();
            var noteName:String;
            for (var i:int = 0; i < respondToMethodsCount; i++) {

                methodXML = respondToMethods[i];
                noteName = methodXML.@uri;
                interests[ interests.length ] = noteName;
            }

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

			var reactionMethods:XMLList = clazzInfo..method.((reactionRegExp as RegExp).test(@name));
			var reactionMethodsCount:int = reactionMethods.length();

			if (reactionMethodsCount == 0) {
				// early exit if no reactions were found
				reactionMethods = null;
				clazzInfo = null;
				return;
			}

			var accessorRegExp:RegExp = new RegExp("(::FabricationMediator$|::Mediator$|Class$)", "");
			var accessorMethods:XMLList = clazzInfo..accessor.(!(accessorRegExp as RegExp).test(@declaredBy));
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

			currentReactions = new Array();

			for (i = 0;i < accessorMethodsCount; i++) {
				handlerName = accessorMethods[i].@name;
				extractRegExp = new RegExp("^" + reactionPattern + "(" + ucfirst(handlerName) + ")" + "(.*)$", "");
				patternList.push(extractRegExp);
			}

            accessorMethodsCount++;
            patternList.push( /^(reactTo|trap)([a-zA-Z0-9]+)\$(.*)$/ );

            var reactionCreated:Boolean = false;
            var fabricationLogger:FabricationLogger = fabFacade.logger as FabricationLogger;
			for (i = 0;i < reactionMethodsCount; i++) {
				handlerName = reactionMethods[i].@name;
                reactionCreated = false;
				for (j = 0;j < accessorMethodsCount; j++) {
					extractRegExp = patternList[j];
					matchResult = extractRegExp.exec(handlerName);
					if (matchResult != null) {


                        if( !matchResult[0] || !matchResult[1] || !matchResult[2] ) {

                            fabricationLogger.error("Wrong reactTo method pattern [ " + handlerName + " ] at [ " + qpath + " ] mediator.");
                            continue;
                        }

						eventPhase = matchResult[1];
						eventSourceName = lcfirst( matchResult[2] );
                        eventSource = this.hasOwnProperty( eventSourceName ) ? this[ eventSourceName ] : ( viewComponent.hasOwnProperty( eventSourceName ) ? viewComponent[eventSourceName] : null );
                        eventType = matchResult[3];
                        if( eventType.indexOf( "$" ) == 0 )
                            continue;
                        eventType = formatEventType( eventType );
						eventHandler = this[handlerName];
						useCapture = eventPhase == captureHandlerPrefix;

                        if (null == eventSource) {
                            fabricationLogger.error("Cannot acces eventSource for Reaction for [ " + eventSourceName + " ] at [ " + qpath + " ] mediator.");
                            break;

                        }

                        addReaction( eventSource, eventType, eventHandler, useCapture );
                        reactionCreated = true;
					}
				}

                if (!reactionCreated) {
                    fabricationLogger.warn("Cannot resolve reaction for [ " + handlerName + " ] at [ " + qpath + " ] mediator.");
                }
			}

			accessorMethods = null;
			reactionMethods = null;
			accessorRegExp = null;
			reactionRegExp = null;
			clazzInfo = null;

		}

        /**
         * Adds reaction to mediator
         * @param source reaction source
         * @param type reaction ( event ) type
         * @param handler reaction handler
         * @param useCapturePhase <b>true</b> if reaction has to be registered on capture phase, otherwise <b>true</b>
         */
        public function addReaction( source:IEventDispatcher, type:String,  handler:Function,  useCapturePhase:Boolean = false ):void {

            if ( !hasReaction( source, type, handler, useCapturePhase ) ) {
                var reaction:Reaction = new Reaction(source, type, handler, useCapturePhase);
                if (currentReactions == null)
                    currentReactions = [];
                currentReactions.push(reaction);
                reaction.start();
            }

        }

        /**
         * Checks if mediator has registered reaction with given props. Source adn type are always
         * checked, handler is compared only if specified. If you don't specify handler reaction will
         * be compared only by source and type
         * @param source reaction source
         * @param type reaction( event ) type
         * @param handler reaction handler
         * @param useCapturePhase <b>true</b> if reaction has to be registered on capture phase, otherwise <b>true</b>
         * @return
         */
        public function hasReaction( source:IEventDispatcher, type:String,  handler:Function = null,  useCapturePhase:Boolean = false ):Boolean {

            if ( currentReactions ) {
                
                var reaction:Reaction = new Reaction(source, type, handler, useCapturePhase);
                var currentReactionCount:uint = currentReactions.length;
                for (var i:int = 0; i < currentReactionCount; ++i) {

                    if (reaction.compare(currentReactions[ i ] as Reaction)) {

                        return true;
                    }

                }
            }
            return false;
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
		 * @param handler The name of the handler or a reference to it.
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
		public override function onRegister():void {
			// This condition check allows the tests with mock mediators to work without
			// additional mocks that are needed to support reactions
			if (multitonKey != null) {
				initializeReactions();
                _reactionsRegistrationPhasePassed = true;
			}
            performInjections();
            
		}


        override public function onRemove():void
        {
            super.onRemove();
            _reactionsRegistrationPhasePassed = false;
        }

        /**
		 * Helper function to invoke the notification handler if it exists.
		 */
		protected function invokeNotificationHandler(name:String, note:INotification):void {


			if (this.hasOwnProperty(name)) {
				    this[name](note);
			}
            else {

                var ns:Namespace = new Namespace( note.getName());
                var q:QName = new QName( ns, "processNotification" );
                if( q && this[ q ] ) {

                        var func:Function = this[ q ] as Function;
                        if (func != null)
                            func.apply(this, [ note ]);
                }

            }
		}

		/**
		 * Checks if input is of the form, CONSTANT_VALUE
		 */
		internal function isConstantFormat(body:String):Boolean {
			return (null != body.match(constantRegExp)) && (body == body.toUpperCase());
		}

		/**
		 * Utility to convert the first character of the string to uppercase.
		 * @private
		 */
		private function ucfirst(body:String):String {
			if (isConstantFormat(body)) {
				return body;
			}

			var result:Object = body.match(firstCharRegExp);
			return body.replace(firstCharRegExp, result[1].toUpperCase());
			//return body.substring(0, 1).toUpperCase() + body.substring(1);
		}

		/**
		 * Utility to convert the first character of the string to lowercase.
		 * @private
		 */
		private function lcfirst(body:String):String {
			if (isConstantFormat(body)) {
				return body;
			}

			var result:Object = body.match(firstCharRegExp);
			return body.replace(firstCharRegExp, result[1].toLowerCase());
			//return body.substring(0, 1).toLowerCase() + body.substring(1);
		}

        protected function formatEventType( body:String ):String {

            var result:Object;
            if( body.indexOf( "_") != -1 ) {
                var parts:Array = body.split("_");
                for( var i:int = 0; i<parts.length; i++ ) {

                    var part:String = parts[i];
                    part = part.toLowerCase();
                    if( i != 0) {

                        result = part.match(firstCharRegExp);
                        part = part.replace(firstCharRegExp, result[1].toUpperCase());
                    }
                    parts[i] = part;


                }
                return parts.join("");
            }

            result = body.match( constantRegExp );
            if( result && body == body.toUpperCase() ) {

                return body.toLowerCase();

            }
            result = body.match(firstCharRegExp);
            return body.replace(firstCharRegExp, result[1].toLowerCase());

        }

        /**
         * Performs injection action on current FlexMediator.
         * By convention we allow proxies and mediators injection on
         * FlexMediator instance
         * @see org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector
         * @see org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector
         */
        protected function performInjections():void
        {
            injectionFieldsNames = [];
            injectionFieldsNames = injectionFieldsNames.concat(( new ProxyInjector(fabFacade, this) ).inject());
            injectionFieldsNames = injectionFieldsNames.concat(( new MediatorInjector(fabFacade, this) ).inject());
            injectionFieldsNames = injectionFieldsNames.concat(( new DependencyInjector(fabFacade, this) ).inject());
        }

        fabrication_internal function get passedReactionsRegistrationPhase():Boolean {

            return _reactionsRegistrationPhasePassed;
        }

        fabrication_internal function get passedNotificationRegistrationPhase():Boolean {

            return qualifiedNotifications != null;
        }
    }
}
