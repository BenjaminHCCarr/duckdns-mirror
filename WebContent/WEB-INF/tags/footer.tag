<%@ tag body-content="empty" dynamic-attributes="dynattrs" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


	<section class="module panels">
		<div class="container">
			<div class="match-alignment">
				<div class="col span-1">
					<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
						<input type="hidden" name="cmd" value="_donations"/>
						<input type="hidden" name="business" value="76WWWMDFVB43A"/>
						<input type="hidden" name="lc" value="GB"/>
						<input type="hidden" name="item_name" value="Duck DNS"/>
						<input type="hidden" name="currency_code" value="GBP"/>
						<input type="hidden" name="no_shipping" value="1"/>
						<input type="hidden" name="return" value="https://www.duckdns.org"/>
						<input type="hidden" name="cbt" value="return to Duck DNS"/>
<c:if test="${not empty dynattrs.isLoggedIn and dynattrs.isLoggedIn eq 'true'}">
						<input type="hidden" name="custom" value="${dynattrs.sessionEmail}"/>
</c:if>
						<input type="hidden" name="image_url" value="https://img/ducky_150x50.png"/>
						<input type="hidden" name="cpp_header_ image" value="https://img/ducky_750x90.png"/>
						<input type="hidden" name="cpp_logo_image" value="https://img/ducky_190x60.png"/>
						<input type="hidden" name="cpp_ headerback_ color" value="006699"/>
						<input type="hidden" name="cpp_ headerborder_color" value="333333"/>
						<input type="image" src="https://www.paypalobjects.com/en_GB/i/btn/btn_donate_LG.gif" border="0" name="submit" title="PayPal - The safer, easier way to pay online."/>
						<img alt="" border="0" src="https://www.paypalobjects.com/en_GB/i/scr/pixel.gif" width="1" height="1"/>
					</form>	
				</div>
				<div class="col span-7" style="text-align: center;">
					<span style="overflow: hidden; border: 1px solid black; -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; padding: 4px; padding-left: 0px; font-family: Arial; font-size: 12px; font-weight: bold; background-color: white;">
						<span style="padding: 4px; padding-left: 8px; background-color: #E98A0A; -webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; color: white;">
							<a href="http://www.bitcoin.org/" style="text-decoration: none; color: white; border: none;">
								<span style="-webkit-border-radius: 10px; -moz-border-radius: 10px; border-radius: 10px; font-weight: normal; color: white; font-size: 15px; background-color: white; color: #E98A0A; padding: 1px 5px; padding-top: 0px;">&#3647;</span>
								Bitcoin
							</a>
						</span>
						<span style="padding: 5px;">
							<a href="bitcoin:16gHnv3NTjpF5ZavMi9QYBFxUkNchdicUS"><span class="bitcoin--full">16gHnv3NTjpF5ZavMi9QYBFxUkNchdicUS</span><span class="bitcoin--small">donate</span></a>
						</span>
					</span>
				</div>
				<div class="col span-3 dogespan" style="text-align: center;">
					<a target="new" href="https://www.patreon.com/user?u=3209735&ty=h&u=3209735"><img style="height:35px;" title="become a Patreon" id="patreon" src="img/patreon.png"/></a>
				</div>
				
				<div class="col span-1 pullright">
					<a target="new" href="https://plus.google.com/communities/111042707043677579973"><img title="join the community" id="community" src="img/gplus_icon.png"/></a>
				</div>
			</div>
		</div>
	</section>
