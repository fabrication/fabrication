package org.puremvc.as3.multicore.utilities.fabrication.addons {
    import com.anywebcam.mock.Mock;

    import flash.utils.getQualifiedClassName;

    import flexunit.framework.Assert;
    import flexunit.framework.AssertionFailedError;

    import mx.utils.StringUtil;
    import mx.utils.UIDUtil;

    public class BaseTestCase {

        static public const EXPECTED_NOT_EQUALS:String = "Expected inequality but was equal to <{0}>";
		static public const EXPECTED_TYPE_EQUALS:String = "Expected <{0}> but was <{1}>";
		static public const EXPECTED_ARRAY_EQUALS:String = "Expected <{0}> but was <{1}>";
		static public const EXPECTED_ARRAY_NOT_EQUALS:String = "Expected inequality but arrays were equal";

        protected var instanceName:String = UIDUtil.createUID();


        public function assertTrue( ...args ):void { Assert.assertTrue.apply( null, args ); }
        public function assertFalse( ...args ):void { Assert.assertFalse.apply( null, args ); }
        public function assertEquals( ...args ):void { Assert.assertEquals.apply( null, args ); }
        public function assertNull( ...args ):void { Assert.assertNull.apply( null, args ); }
        public function assertNotNull( ...args ):void { Assert.assertNotNull.apply( null, args ); }
        public function assertMatch( ...args ):void { Assert.assertMatch.apply( null, args ); }
        public function assertNoMatch( ...args ):void { Assert.assertNoMatch.apply( null, args ); }
        public function assertObjectEquals( ...args ):void { Assert.assertObjectEquals.apply( null, args ); }
        public function assertContained( ...args ):void { Assert.assertContained.apply( null, args ); }
        public function assertNotContained( ...args ):void { Assert.assertNotContained.apply( null, args ); }

        public function fail( ...args):void { Assert.fail.apply( null, args ); }


        public function verifyMock( mock:Mock ):void {

            Assert.oneAssertionHasBeenMade();
            mock.verify();


        }

        public function assertNotEquals(...rest):void {
            
			try {
				Assert.assertEquals.apply(Assert, rest);

				var failMessage:String;
				if (rest.length == 3) {
					failMessage = StringUtil.substitute(EXPECTED_NOT_EQUALS, rest[1], rest[2]);
					Assert.fail(rest[0] + failMessage);
				} else {
					failMessage = StringUtil.substitute(EXPECTED_NOT_EQUALS, rest[0], rest[1]);
					Assert.fail(failMessage);
				}
			} catch (error:AssertionFailedError) {
				// assertion failed indicates inequality
			}
		}

        public function assertProperty(...rest):void
        {
            var propertyName:String;
            var propertyValue:*;
            var source:Object;
            var failMessage:String = "";
            var getterName:String;
            var setterName:String;
            var expectedType:Class;
            var defaultValue:*;

            if (rest.length == 6) {
                failMessage = rest[0];
                source = rest[1];
                propertyName = rest[2];
                expectedType = rest[3];
                defaultValue = rest[4];
                propertyValue = rest[5];
            }
            else {
                source = rest[0];
                propertyName = rest[1];
                expectedType = rest[2];
                defaultValue = rest[3];
                propertyValue = rest[4];
            }

            var typeName:String = getClassName(expectedType);

            getterName = propertyName;
            setterName = propertyName;

            assertTrue( failMessage + "Expected property named " + getterName + ".", source.hasOwnProperty(getterName));

            if (defaultValue != null) {
                assertType(failMessage + "Expected property to return " + typeName + ".", expectedType, source[getterName]);
            }

            assertTrue(failMessage + "Expected property named " + setterName + ".", source.hasOwnProperty(setterName));

            source[setterName] = propertyValue;

            if (defaultValue == null && propertyValue != null) {
                assertType(failMessage + "Expected property to return " + typeName + ".", expectedType, source[getterName]);
            }

            assertEquals(failMessage + "Expected property (" + setterName + ") to be saved ", propertyValue, source[getterName]);
        }

        public function assertGetterAndSetter(...rest):void {
			var propertyName:String;
			var propertyValue:Object;
			var source:Object;
			var failMessage:String = "";
			var getterName:String;
			var setterName:String;
			var expectedType:Class;
			var defaultValue:Object;

			if (rest.length == 6) {
				failMessage = rest[0];
				source = rest[1];
				propertyName = rest[2];
				expectedType = rest[3];
				defaultValue = rest[4];
				propertyValue = rest[5];
			} else {
				source = rest[0];
				propertyName = rest[1];
				expectedType = rest[2];
				defaultValue = rest[3];
				propertyValue = rest[4];
			}

			var typeName:String = getClassName(expectedType);

			getterName = "get" + propertyName.charAt(0).toUpperCase() + propertyName.substring(1);
			setterName = "set" + propertyName.charAt(0).toUpperCase() + propertyName.substring(1);

			assertTrue(failMessage + "Expected getter named " + getterName, source.hasOwnProperty(getterName));

			if (defaultValue != null) {
				assertType(failMessage + "Expected getter to return " + typeName, expectedType, source[getterName]());
			}

			assertTrue(failMessage + "Expected setter named " + setterName, source.hasOwnProperty(setterName));

			source[setterName](propertyValue);

			if (defaultValue == null && propertyValue != null) {
				assertType(failMessage + "Expected getter to return " + typeName, expectedType, source[getterName]());
			}

			assertEquals(failMessage + "Expected setter (" + setterName + ") to save " + propertyValue, propertyValue, source[getterName]());
		}

        public function assertArrayEquals(...rest):void {
			var failMessage:String;

			if (rest.length == 3) {
				failMessage = StringUtil.substitute(EXPECTED_ARRAY_EQUALS, rest[1], rest[2]);
				testArrayEquality(rest[1], rest[2], failMessage + rest[0]);
			} else {
				failMessage = StringUtil.substitute(EXPECTED_ARRAY_EQUALS, rest[0], rest[1]);
				testArrayEquality(rest[0], rest[1]);
			}
		}

        public function testArrayEquality(array1:Array, array2:Array, message:String = ""):void {
			assertEquals("Array length not equal", array1.length, array2.length);
			var n:int = array1.length;

			for (var i:int = 0; i < n; i++) {
				assertEquals(message, array1[i], array2[i]);
			}
		}

        public function assertType(...rest):void {
			var failMessage:String;

			Assert.oneAssertionHasBeenMade();

			if (rest.length == 3) {
				if (!(rest[2] is ( rest[1] as Class ))) {
					failMessage = StringUtil.substitute(EXPECTED_TYPE_EQUALS, getClassName(rest[1]), getClassName(rest[2]));
					fail(rest[0] + failMessage);
				}
			} else if (!(rest[1] is ( rest[0] as Class ))){
				failMessage = StringUtil.substitute(EXPECTED_TYPE_EQUALS, getClassName(rest[0]), getClassName(rest[1]));
				fail(failMessage);
			}
		}

        public function getClassName(clazz:Object):String {

			var classpath:String = getQualifiedClassName(clazz);
			var re:RegExp = new RegExp("^.*::(.*)$", "");
			var result:Object = re.exec(classpath);

			if (result != null) {
				return result[1];
			} else {
				return classpath;
			}
		}

        public function nullarg(arg:Object = null):Boolean {
			return arg == null;
		}


    }
}