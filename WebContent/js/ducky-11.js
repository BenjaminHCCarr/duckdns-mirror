$(document).ready(function() {
	$(".deleteaccount").click(function(event) {
	    if (!confirm('are you sure that you want to delete your account?')) { 
	    	event.preventDefault(); 
	    }
	    if (!confirm('are you sure you\'re sure that you want to delete your account?')) { 
	    	event.preventDefault(); 
	    }
	});
	$(".deletedomains").click(function(event) {
	    if (!confirm('are you sure that you want to delete the domain '+encodeURI($(this).children("div").children("button").attr('value'))+'.duckdns.org?')) { 
	    	event.preventDefault(); 
	    }
	});
	$(".recreatetoken").click(function(event) {
	    if (!confirm('are you sure that you want to recreate your token?')) { 
	    	event.preventDefault(); 
	    }
	});
	$("#accountOptionsToggle").click(function(event) {
		event.preventDefault(); 
		$("#accountOptionsHolder").toggle();
	});
	$("#adddomain").click(function(event) {
	    $(this).parent("div").parent("form").submit();
	});
	$(".updateips").click(function(event) {
	    $(this).parent("div").parent("form").submit();
	});
	$("#install-selectdomain").change(function() {
		$(this).parent("div").parent("form").submit();
	});
	
	$('.nav-tabs #nav-linux-gui a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("linux-gui");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#linux-gui").show();
		$("img.hidden-linux-gui").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-linux-cron a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("linux-cron");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#linux-cron").show();
	});
	$('.nav-tabs #nav-dotnet-core-script a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("dotnet-core-script");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#dotnet-core-script").show();
		$("img.hidden-dotnet-core-script").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-windows-script a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("windows-script");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#windows-script").show();
		$("img.hidden-windows-script").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-windows-gui a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("windows-gui");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#windows-gui").show();
		$("img.hidden-windows-gui").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-windows-powershell a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("windows-powershell");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#windows-powershell").show();
		$("img.hidden-windows-powershell").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-osx a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("osx");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#osx").show();
	});
	$('.nav-tabs #nav-osx-homebrew a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("osx-homebrew");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#osx-homebrew").show();
	});
	$('.nav-tabs #nav-pi a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("pi");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#pi").show();
	});
	$('.nav-tabs #nav-raspbmc a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("raspbmc");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#raspbmc").show();
	});
	$('.nav-tabs #nav-ec2 a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("ec2");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#ec2").show();
	});
	$('.nav-tabs #nav-openwrt a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("openwrt");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#openwrt").show();
	});
	$('.nav-tabs #nav-tomatousb a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("tomatousb");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#tomatousb").show();
		$("img.hidden-tomatousb").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-mikrotik a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("mikrotik");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#mikrotik").show();
	});
	$('.nav-tabs #nav-fritzbox a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("fritzbox");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#fritzbox").show();
	});
	$('.nav-tabs #nav-android a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("android");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#android").show();
		$("img.hidden-android").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-pfsense a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("pfsense");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#pfsense").show();
		$("img.hidden-pfsense").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-gnudip a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("gnudip");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#gnudip").show();
		$("img.hidden-gnudip").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-ddwrt a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("ddwrt");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#ddwrt").show();
		$("img.hidden-ddwrt").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-allied-telesis a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("alliedtelesis");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#alliedtelesis").show();
	});
	$('.nav-tabs #nav-technicolor a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("technicolor");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#technicolor").show();
		$("img.hidden-technicolor").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-zteh108n a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("zteh108n");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#zteh108n").show();
		$("img.hidden-zteh108n").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-dyndns a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("dyndns");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#dyndns").show();
		$("img.hidden-dyndns").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-inadyn a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("inadyn");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#inadyn").show();
		$("img.hidden-inadyn").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-dnsomatic a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("dnsomatic");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#dnsomatic").show();
		$("img.hidden-dnsomatic").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-osx-ios-realdns a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("osx-ios-realdns");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#osx-ios-realdns").show();
		$("img.hidden-osx-ios-realdns").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-freenas a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("freenas");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#freenas").show();
		$("img.hidden-freenas").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-osx-ip-monitor a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("osx-ip-monitor");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#osx-ip-monitor").show();
		$("img.hidden-osx-ip-monitor").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-hardware a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("hardware");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#hardware").show();
		$("img.hidden-hardware").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-windows-csharp a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("windows-csharp");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#windows-csharp").show();
		$("img.hidden-windows-csharp").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-linux-bsd-cron a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("linux-bsd-cron");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#linux-bsd-cron").show();
		$("img.hidden-linux-bsd-cron").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-edgerouter a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("edgerouter");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#edgerouter").show();
		$("img.hidden-edgerouter").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-mono a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("mono");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#mono").show();
		$("img.hidden-mono").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-smoothwall a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("smoothwall");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#smoothwall").show();
		$("img.hidden-smoothwall").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-synology a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("synology");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#synology").show();
		$("img.hidden-synology").reveal("fadeIn", 1000);
	});
	$('.nav-tabs #nav-linux-netcat-cron a').click(function (e) {
		e.preventDefault();
		$('input#hiddenTabInput').val("linux-netcat-cron");
		$("#all-tabs").children().hide();
		$(".nav-tabs").children().removeClass("active");
		$(this).parent().addClass("active");
		$("#linux-netcat-cron").show();
		$("img.hidden-linux-netcat-cron").reveal("fadeIn", 1000);
	});
	(function($){
	    $.fn.reveal = function(){
	        var args = Array.prototype.slice.call(arguments);
	        return this.each(function(){
	            var img = $(this),
	                src = img.data("src");
	            src && img.attr("src", src).load(function(){
	                img[args[0]||"show"].apply(img, args.splice(1));
	            });
	        });
	    };
	})(jQuery);
});