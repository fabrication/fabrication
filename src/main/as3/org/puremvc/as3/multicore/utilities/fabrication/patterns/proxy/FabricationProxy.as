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
 
package org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy {
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
	import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;	

	/**
	 * FabricationProxy is the base Proxy class for fabrication proxies.
	 * It provides part name based notifications.
	 * 
	 * @author Darshan Sawardekar
	 */
	public class FabricationProxy extends Proxy implements IDisposable {

		/**
		 * Default name of a FabricationProxy
		 */
		static public const NAME:String = "FabricationProxy";
		
		/**
		 * System notification used to indicate that a notification has been
		 * sent by a Proxy. 
		 */
		static public const NOTIFICATION_FROM_PROXY:String = "notificationFromProxy";
		
		/**
		 * Stores the default proxy names calculated using reflection.
		 */
		static public var cachedProxyNames:Object = new Object();
		
		/**
		 * Regular expression used to extract the classname from the classpath.
		 */
		static private const classRegExp:RegExp = new RegExp(".*::(.*)$", "");
		
		/**
		 * Creates a new FabricationProxy object.
		 */
		public function FabricationProxy(name:String = null, data:Object = null) {
			super(name, data);
		}
		
		/**
		 * @see org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable#dispose()
		 */
		public function dispose():void {
			data = null;
		}
		
		/**
		 * Returns the full name for the specified notification. If the
		 * name of the Proxy is the same as Proxy.NAME then no prefix is
		 * used else the name of the proxy is prefixed to the notification.
		 * 
		 * @example For the Proxy SampleProxy with the name MySampleProxy,
		 * 			the notification Changed becomes, MySampleProxy/Changed 
		 */
		public function getNotificationName(note:String):String {
			var proxyName:String = getProxyName();
			if (proxyName == getDefaultProxyName() || proxyName == Proxy.NAME) {
				return note;
			} else {
				return proxyName + "/" + note;
			}
		}
		
		/**
		 * Calculates the default name of the current proxy using reflection.
		 * The name is cached and the cached name is used in subsequent invocations.
		 */
		public function getDefaultProxyName():String {
			if (hasCachedDefaultProxyName()) {
				return getCachedDefaultProxyName();
			}
			
			var qpath:String = getQualifiedClassName(this);
			var classpath:String = qpath;
			var classname:String;
			var matchResult:Object = classRegExp.exec(classpath);
			
			if (matchResult != null) {
				classname = matchResult[1];
			} else {
				classname = classpath;
			}
			
			classpath.replace("::", ".");
			
			var fabrication:IFabrication = fabFacade.getApplication() as IFabrication;
			var clazz:Class = fabrication.getClassByName(classpath);
			var clazzInfo:XML = describeType(clazz);
			var constants:XMLList = clazzInfo..constant.(@name == "NAME");
			var proxyName:String;

			if (constants.length() == 1) {
				proxyName = clazz["NAME"];
			} else {
				proxyName = classname;
			}
			
			cachedProxyNames[qpath] = proxyName;
			
			return proxyName;
		}
		
		/**
		 * Overrides the default send notification to qualify the notification
		 * if needed prior to sending it. Also sends a NOTIFICATION_FROM_PROXY
		 * system notification which can be used by mediators to listen
		 * to a mediators notification using respondToProxyName methods.  
		 */
		override public function sendNotification(noteName:String, noteBody:Object = null, noteType:String = null):void {
			noteName = getNotificationName(noteName);
			
			var notification:INotification = new Notification(noteName, noteBody, noteType);
			
			super.sendNotification(noteName, noteBody, noteType);
			super.sendNotification(NOTIFICATION_FROM_PROXY, notification, getProxyName());
		}
		
		/**
		 * Routes a notification to all modules using facade.routeNotification.
		 */
		public function routeNotification(noteName:String, noteBody:Object = null, noteType:String = null, to:String = null):void {
			if (fabFacade != null) {
				fabFacade.routeNotification(noteName, noteBody, noteType, to);
			}
		}

		/**
		 * Alias to fabrication facade.
		 */		
		protected function get fabFacade():FabricationFacade {
			return facade as FabricationFacade;
		}
		
		/**
		 * Returns true if the default proxy name was cached earlier.
		 */
		protected function hasCachedDefaultProxyName():Boolean {
			return getCachedDefaultProxyName() != null;
		}

		/**
		 * Returns the cached default proxy name.
		 */
		protected function getCachedDefaultProxyName():String {
			return cachedProxyNames[getQualifiedClassName(this)];
		}
	}
}
