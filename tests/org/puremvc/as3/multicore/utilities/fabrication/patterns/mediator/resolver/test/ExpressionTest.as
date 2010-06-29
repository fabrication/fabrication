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

package org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.test {
    import mx.core.UIComponent;

    import org.puremvc.as3.multicore.utilities.fabrication.addons.BaseTestCase;
    import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.mock.FacadeMock;
    import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.resolver.*;

    /**
     * @author Darshan Sawardekar
     */
    public class ExpressionTest extends BaseTestCase {

        public var expr:Expression;
        public var resolver:ComponentResolver;


        [Before]
        public function setUp():void
        {
            resolver = new ComponentResolver(
                    new UIComponent(), new FacadeMock(instanceName), new ComponentRouteMapper()
                    );
        }

        [After]
        public function tearDown():void
        {
            resolver = null;
        }

        [Test]
        public function testExpressionHasValidType():void
        {
            expr = new Expression(/.*/);
            assertType(Expression, expr);
            assertType(IDisposable, expr);
        }

        [Test]
        public function testExpressionConstructorWithOnlyPattern():void
        {
            expr = new Expression(/.*/);

            assertEquals(".*", expr.source);
            assertNull(expr.root);
        }

        [Test]
        public function testExpressionConstructorWithPatternAndRootComponentResolver():void
        {
            expr = new Expression(/.*/, resolver);

            assertEquals(".*", expr.source);
            assertEquals(resolver, expr.root);
        }

        [Test]
        public function testExpressionHasValidDescendantPatternStringConstant():void
        {
            var re:RegExp = new RegExp(Expression.DESCENDANT_PATTERN, "");
            assertMatch(re, "abc");
            assertMatch(re, "abc123");
            assertMatch(re, "abc_123_xyz");
        }

        [Test]
        public function testExpressionHasValidSeparatorPatternConstant():void
        {
            var re:RegExp = new RegExp(Expression.SEPARATOR_PATTERN, "");
            assertMatch(re, "abc.xyz");
            assertMatch(re, "a.b.c");
            assertNoMatch(re, "abc");
            assertNoMatch(re, "a_b_c");
        }

        [Test]
        public function testExpressionHasValidDescendantPatternRegularExpressionConstant():void
        {
            var re:RegExp = Expression.descendantRegExp;
            assertMatch(re, "abc");
            assertMatch(re, "abc123");
            assertMatch(re, "abc_123_xyz");
        }

        [Test]
        public function testExpressionProvidesStaticReExpressionGeneratorWithBaseExpression():void
        {
            var baseExpr:Expression = new Expression(/.*/);
            var pattern:String = instanceName;
            var expr:Expression = Expression.reExpression(baseExpr, new RegExp(pattern, ""));

            assertType(Expression, expr);
            assertEquals(baseExpr.child, expr);
            assertEquals(pattern, expr.source);
        }

        [Test]
        public function testExpressionProvidesStaticReExpressionGeneratorWithoutBaseExpression():void
        {
            var pattern:String = instanceName;
            var expr:Expression = Expression.reExpression(null, new RegExp(pattern, ""));

            assertType(Expression, expr);
            assertEquals(pattern, expr.source);
        }

        [Test]
        public function testExpressionProvidesStaticNameExpressionGenerator():void
        {
            var expr:Expression = Expression.nameExpression(null, instanceName);
            assertType(Expression, expr);
            assertEquals(instanceName, expr.source);
        }

        [Test]
        public function testExpressionProvidesStaticDescendantsExpressionGenerator():void
        {
            var expr:Expression = Expression.descendantsExpression(null, instanceName);
            var nameExpression:Expression = expr.child;

            assertType(Expression, expr);
            assertType(Expression, nameExpression);

            assertEquals(Expression.DESCENDANT_PATTERN, expr.source);
            assertEquals(instanceName, nameExpression.source);
        }

        [Test]
        public function testReExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var child:Expression = expr.re(instanceName);

            assertType(Expression, child);
            assertEquals(instanceName, child.source);
            assertEquals(expr.child, child);
            assertEquals(resolver, child.root);
            assertTrue(resolver.getMultimode());

            child = expr.re(instanceName, false);
            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function testRexExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var descExpr:Expression = expr.rex(instanceName);
            var reExpr:Expression = descExpr.child;

            assertType(Expression, descExpr);
            assertEquals(expr.child, descExpr);
            assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
            assertEquals(reExpr, descExpr.child);
            assertEquals(instanceName, reExpr.source);

            assertTrue(resolver.getMultimode());
            descExpr = expr.rex(instanceName, false);
            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function testDescendantsExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var descExpr:Expression = expr.descendants(instanceName);
            var nameExpr:Expression = descExpr.child;

            assertType(Expression, descExpr);
            assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);

            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function testNamedExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var nameExpr:Expression = expr.resolve(instanceName);

            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);
            assertFalse(resolver.getMultimode());

            nameExpr = expr.resolve(instanceName, true);
            assertTrue(resolver.getMultimode());
        }

        [Test]
        public function testExpressionAllowsLinkingToChildExpression():void
        {
            var expr:Expression = new Expression(/start/);
            var child:Expression = new Expression(/child/);

            expr.link(child);

            assertEquals(child, expr.child);
        }

        [Test]
        public function testExpressionMatchesPatternWithContentString():void
        {
            var expr:Expression = new Expression(new RegExp(instanceName, ""));
            assertTrue(expr.match(instanceName));
            assertFalse(expr.match("007"));
            assertFalse(expr.match("test"));
        }

        [Test]
        public function testExpressionProvidesDirectionBasedIterator():void
        {
            var expr:Expression = new Expression(/abc/);
            var iterator:ExpressionIterator = expr.getIterator();

            assertType(ExpressionIterator, iterator);
            assertEquals(ExpressionIterator.BACKWARD, iterator.getDirection());

            iterator = expr.getIterator(ExpressionIterator.FORWARD);
            assertEquals(ExpressionIterator.FORWARD, iterator.getDirection());
        }

        [Test]
        public function testExpressionExpansionIsValid():void
        {
            var expr:Expression = new Expression(/a/);
            expr.resolve("b").resolve("c");

            assertEquals("(a\\.b\\.c)", expr.expand().source);
        }

        [Test]
        public function testDynamicPropertyNameExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var nameExpr:Expression = expr[instanceName];

            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);
            assertEquals(nameExpr, expr.child);

            nameExpr = expr.myProperty;
            assertEquals("myProperty", nameExpr.source);

            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function testDynamicNLevelPropertyNameExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/harry/);
            expr.ron.hermione.hagrid.dumbledore;

            assertEquals("(harry\\.ron\\.hermione\\.hagrid\\.dumbledore)", expr.expand().source);
        }

        [Test]
        public function testDynamicMethodNameExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var nameExpr:Expression = expr[ instanceName ];

            assertType(Expression, nameExpr);
            assertEquals(instanceName, nameExpr.source);
            assertEquals(nameExpr, expr.child);

            nameExpr = expr.myProperty();
            assertEquals("myProperty", nameExpr.source);

            assertTrue(resolver.getMultimode());

            nameExpr = expr.multiProperty(false);
            assertFalse(resolver.getMultimode());

            nameExpr = expr.multiProperty(true);
            assertTrue(resolver.getMultimode());
        }

        [Test]
        public function testDynamicDescendantsExpressionBuildsValidLinkedExpression():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            var descExpr:Expression = expr..myComponent;
            var nameExpr:Expression = descExpr.child;

            assertType(Expression, descExpr);
            assertEquals(Expression.DESCENDANT_PATTERN, descExpr.source);
            assertType(Expression, nameExpr);
            assertEquals("myComponent", nameExpr.source);

            assertFalse(resolver.getMultimode());
        }

        [Test]
        public function testExpressionResetsAfterDisposal():void
        {
            var expr:Expression = new Expression(/start/, resolver);
            expr..myProperty;

            expr.dispose();

            assertNull(expr.root);
            assertNull(expr.child);
        }

    }
}
