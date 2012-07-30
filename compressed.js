(function(){var k=[].indexOf||function(f){for(var d=0,c=this.length;d<c;d++)if(d in this&&this[d]===f)return d;return-1};(function(f){return f.fn.getCursorPosition=function(){var d,c,g;d=f(this).get(0);c=0;"selectionStart"in d?c=d.selectionStart:0<=k.call(document,"selection")&&(d.focus(),c=document.selection.createRange(),g=document.selection.createRange().text.length,c.moveStart("character",-d.value.length),c=c.text.length-g);return c}})(jQuery);(function(f){return f.fn.setCursorPosition=function(d,
c){return this.each(function(){var g;if(this.setSelectionRange)return this.focus(),this.setSelectionRange(d,c);if(this.createTextRange)return g=this.createTextRange,g.collapse(!0),g.moveEnd("character",c),g.moveStart("character",d),g.select()})}})(jQuery)}).call(this);(function(){var k,f,d,c,g,a,e,j,h;Array.prototype.type="JList";j=function(b){return b.rest===Lisp.Nil?b.first:""+b.first+" "+j(b.rest)};e=function(){function b(b){this.value=""+b}b.name="LispSymbol";b.prototype.toString=function(){return"'"+this.value};b.prototype.type="Symbol";return b}();h=new (function(){function b(){}b.name="SymbolFactory";b.prototype.get=function(b){return b in this?this[b]:this[b]=new e(b)};return b}());d=function(){function b(){this.value=null}b.name="LispNil";b.prototype.toString=
function(){return"'()"};b.prototype.type="Nil";return b}();k=function(){function b(b){this.value=b}b.name="LispBoolean";b.prototype.toString=function(){return this.value?"#t":"#f"};b.prototype.type="Boolean";return b}();f=function(){function b(b,a){this.first=b;this.rest=a}b.name="LispCons";b.prototype.toString=function(){var b;return"Cons"===(b=this.rest.type)||"Nil"===b?"'("+j(this)+")":"'("+this.first.toString()+" . "+this.rest.toString()+")"};b.prototype.type="Cons";return b}();c=function(){function b(b){this.value=
b}b.name="LispNumber";b.prototype.toString=function(){return""+this.value};b.prototype.valueOf=function(){return this.value};b.prototype.type="Number";return b}();g=function(){function b(b){this.value=b}b.name="LispQuoted";b.prototype.type="Quoted";return b}();a=function(){function b(b){this.value=b}b.name="LispString";b.prototype.toString=function(){return'"'+this.value+'"'};b.prototype.valueOf=function(){return this.value};b.prototype.type="String";return b}();window.Lisp={Cons:f,False:new k(!1),
Nil:new d,Number:c,Procedure:function(b,a){a.toString=function(){return"#<procedure:"+b+">"};a.type="Procedure";return a},Quoted:g,String:a,Symbol:function(b){return h.get(b)},True:new k(!0)}}).call(this);(function(){var k,f,d,c,g=[].slice;k={"+":new Lisp.Procedure("+",function(a){return a.reduce(function(a,c){return new Lisp.Number(a.value+c.value)})}),"-":new Lisp.Procedure("-",function(a){return a.reduce(function(a,c){return new Lisp.Number(a.value-c.value)})}),"*":new Lisp.Procedure("*",function(a){return a.reduce(function(a,c){return new Lisp.Number(a.value*c.value)})}),"/":new Lisp.Procedure("/",function(a){return a.reduce(function(a,c){return new Lisp.Number(a.value/c.value)})}),">":new Lisp.Procedure(">",
function(a){return a[0]>a[1]?Lisp.True:Lisp.False}),">=":new Lisp.Procedure(">=",function(a){return a[0]>=a[1]?Lisp.True:Lisp.False}),"<":new Lisp.Procedure("<",function(a){return a[0]<a[1]?Lisp.True:Lisp.False}),"<=":new Lisp.Procedure("<=",function(a){return a[0]<=a[1]?Lisp.True:Lisp.False}),"eq?":new Lisp.Procedure("eq?",function(a){return"Number"===a[0].type?a[0].value===a[1].value?Lisp.True:Lisp.False:a[0]===a[1]?Lisp.True:Lisp.False}),"type?":new Lisp.Procedure("type?",function(a){return new Lisp.Symbol(a[0].type)}),
and:new Lisp.Procedure("and",function(a){return a.every(function(a){return a===Lisp.True})?Lisp.True:Lisp.False}),or:new Lisp.Procedure("or",function(a){return a.some(function(a){return a===Lisp.True})?Lisp.True:Lisp.False}),not:new Lisp.Procedure("not",function(a){return a[0]===Lisp.True?Lisp.False:Lisp.True}),cons:new Lisp.Procedure("cons",function(a){return new Lisp.Cons(a[0],a[1])}),first:new Lisp.Procedure("first",function(a){return a[0].first}),rest:new Lisp.Procedure("rest",function(a){return a[0].rest}),
last:new Lisp.Procedure("last",function(a){var c;c=function(a){return a.rest===Lisp.Nil?a.first:c(a.rest)};return c(a[0])}),print:new Lisp.Procedure("print",function(a){var c;c=$("#console");window.FIRST_PRINT?(c.val(""+c.val()+"\n"+a[0].toString()),window.FIRST_PRINT=!1):c.val(""+c.val()+a[0].toString())})};f=function(){function a(a,c,h){var b,l,d;null==a&&(a=[]);null==c&&(c=[]);this.parent=null!=h?h:null;h=l=0;for(d=a.length;l<d;h=++l)b=a[h],this[b.value]=c[h]}a.name="Environment";a.prototype.find=
function(a){try{return a in this?this[a]:this.parent.find(a)}catch(c){throw"reference to undefined identifier: "+a;}};a.prototype.findEnvironment=function(a){try{return a in this?this:this.parent.findEnvironment(a)}catch(c){throw"set!: cannot set variable before its definition: "+a;}};a.prototype.updateValues=function(a){var c,h,b;b=[];for(c in a)h=a[c],b.push(this[c]=h);return b};return a}();c=new f;c.updateValues(k);d=function(a,e){var j,h,b,l,n,i,p,o,k,m;null==e&&(e=c);if("JList"===a.type)switch(a[0].value){case "define":return i=
a[1],h=3<=a.length?g.call(a,2):[],"JList"===i.type?(j=i[0],h.unshift(new Lisp.Symbol("begin")),e[j.value]=new Lisp.Procedure(j.value,function(a){return d(h,new f(i.slice(1),a,e))})):e[i.value]=d(h[0],e);case "lambda":return p=a[1],h=a[2],new Lisp.Procedure("lambda",function(a){return d(h,new f(p,a,e))});case "if":return n=a[1],l=a[2],j=a[3],h=d(n,e)===Lisp.True?l:j,d(h,e);case "let":j=a[1];h=a[2];n=[];l=[];k=0;for(m=j.length;k<m;k++)o=j[k],n.push(o[0]),l.push(d(o[1],e));return d(h,new f(n,l,e));case "set!":return i=
a[1],l=a[2],j=e.findEnvironment(i.value),j[i.value]=d(l,e);case "begin":return b=a.slice(1),function(){var a,c,l;l=[];a=0;for(c=b.length;a<c;a++)h=b[a],l.push(d(h,e));return l}().pop();default:return j=function(){var b,c,h;h=[];b=0;for(c=a.length;b<c;b++)o=a[b],h.push(d(o,e));return h}(),l=j.shift(),l(j)}else return"Symbol"===a.type?e.find(a.value):"Quoted"===a.type?a.value:a};window.evalExpression=d;window.globalEnvironment=c;window.resetGlobalEnvironment=function(){c=new f;return c.updateValues(k)}}).call(this);(function(){var k,f,d;f=function(c){var g;g=c.shift();if("("===g){for(g=[];")"!==c[0];)g.push(f(c));c.shift();return g}if("'("===g){for(g=[];")"!==c[0];)g.push(f(c));c.shift();return new Lisp.Quoted(k(g))}return d(g)};d=function(c){var d;if("true"===c)return Lisp.True;if("false"===c)return Lisp.False;if("nil"===c)return Lisp.Nil;d=Number(c.replace(/^'/,""));return isNaN(d)?"'"===c.charAt(0)?new Lisp.Quoted(new Lisp.Symbol(c.replace(/^'/,""))):'"'===c.charAt(0)?new Lisp.String(c.slice(1,-1)):new Lisp.Symbol(c):
new Lisp.Number(d)};k=function(c){return 0===c.length?Lisp.Nil:new Lisp.Cons(c.shift(),k(c))};window.tokenize=function(c){var d,a,e,f,h;d=/^\s*$/;c=c.replace(/;+.+\n|\n|\r|\t/g," ");c=c.replace(/\(/g," ( ");c=c.replace(/\)/g," ) ");c=c.replace(/'\s+\(/g,"'(");a=c.split(/("[^"]+"|[^"\s]+)/g);h=[];e=0;for(f=a.length;e<f;e++)c=a[e],d.test(c)||h.push(c);return h};window.parseTokens=f}).call(this);(function(){var k,f,d,c,g,a,e,j;$(function(){var a,b,l,k,i;l=$("#input");i=$("#console");k=$("#navbar");a=$("#button-group");a=$(window).height()-(k.height()+a.height())-50;l.height(a);i.height(a);i.val("> ");i.keydown(f);i.keyup(d);i.mousedown(g);$("#run").click(j);$("#save").popover({placement:"bottom",title:"Choose a name",trigger:"manual",content:'<input type="text" id="filename">'});$("#save").click(function(){$(this).popover("toggle");return $("#filename").keydown(e)});l=$("#dropdown");for(b in localStorage)l.append("<li><a href='#'>"+
b+"</a></li>");return l.children().click(c)});c=function(){var a;a=localStorage.getItem(this.firstChild.text);return $("#input").val(a)};e=function(a){var b,d;if(13===a.which)return b=$("#dropdown"),d=$(this),a=$("#input").val(),localStorage.setItem(d.val(),a),$("#save").popover("hide"),b.append("<li><a href='#'>"+d.val()+"</a></li>"),b.children().click(c),d.val("")};j=function(){var a,b,c,d,i,f;d=$("#input").val();a=f=c=i=0;for(b=[];i<d.length;)if("("===d.charAt(i)&&(f+=1,1===f&&0===a&&(c=i)),")"===
d.charAt(i)&&(a+=1),i+=1,0<f&&f===a)a=d.slice(c,i),b.push(a),a=f=0;c=0;for(d=b.length;c<d;c++)a=b[c],evalExpression(parseTokens(tokenize(a)))};g=function(a){var b;b=$("#console");a.preventDefault();a=b.val().length;if(!b.is(":focus"))return b.setCursorPosition(a,a)};a=!1;f=function(){var c,b,d,f;d=[];b=[];c=0;f=void 0;return function(i){var g,e,j,m;a=!1;m=$("#console");j=m.val();e=function(){var a;a=m.getCursorPosition();if(2>=a||"\n> "===j.slice(a-3,a))return i.preventDefault()};switch(i.which){case 38:-1===
c&&(c=b.length-1);if(g=b[c])e=m.val().split("\n").pop(),g=""+j.slice(0,j.lastIndexOf(e))+"> "+g.trim(),m.val(g),c-=1;i.preventDefault();break;case 37:e();break;case 8:e();break;case 13:e=m.val().split("\n").pop();e=e.replace("> ","");d.push(e+" ");e=d.reduce(function(a,b){return a+b});if(k(e)){b.push(e);c=b.length-1;e=tokenize(e);e=parseTokens(e);try{g=evalExpression(e),null!=g&&m.val(""+j+"\n"+g.toString())}catch(q){m.val(""+j+"\n"+q.toString())}a=!0;d=[]}break;case 67:17===f&&(i.preventDefault(),
m.val(j+"\n> "),d=[])}return f=i.which}}();d=function(){var c,b;b=$("#console");if(a)return c=b.val(),b.val(c+"> "),window.FIRST_PRINT=!0};k=function(a){var b;b=a.split("(").length-1;a=a.split(")").length-1;return b<=a};window.FIRST_PRINT=!0}).call(this);