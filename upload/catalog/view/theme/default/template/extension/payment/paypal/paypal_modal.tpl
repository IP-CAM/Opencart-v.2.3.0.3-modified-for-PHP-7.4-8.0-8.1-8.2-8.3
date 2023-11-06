<div id="paypal_modal" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fal fa-close"></i></button>
				<h4 class="modal-title"><?php echo $text_paypal_title; ?></h4>
			</div>
			<div class="modal-body">
				<div id="paypal_form">
					<?php if ($button_status) { ?>
					<div id="paypal_button" class="paypal-button buttons clearfix">
						<div id="paypal_button_container" class="paypal-button-container paypal-spinner"></div>
					</div>
					<?php } ?>
					<?php if ($googlepay_button_status) { ?>
					<div id="googlepay_button" class="googlepay-button buttons clearfix">
						<div id="googlepay_button_container" class="googlepay-button-container paypal-spinner"></div>
					</div>
					<?php } ?>
					<?php if ($applepay_button_status) { ?>
					<div id="applepay_button" class="applepay-button buttons clearfix">
						<div id="applepay_button_container" class="applepay-button-container paypal-spinner"></div>
					</div>
					<?php } ?>
					<?php if ($card_status) { ?>
					<div id="paypal_card" class="paypal-card">
						<div id="paypal_card_container" class="paypal-card-container paypal-spinner">
							<form id="paypal_card_form" class="paypal-card-form well">
								<div class="card-info-number clearfix">
									<label for="card_number" class="card-label"><?php echo $entry_card_number; ?></label>
									<div id="card_number" class="card-input-container"><div id="card_image"></div></div>
								</div>
								<div class="card-info-date-cvv clearfix">
									<div class="card-info-date">
										<label for="expiration_date" class="card-label"><?php echo $entry_expiration_date; ?></label>
										<div id="expiration_date" class="card-input-container"></div>
									</div>
									<div class="card-info-cvv">
										<label for="cvv" class="card-label"><?php echo $entry_cvv; ?></label>
										<div id="cvv" class="card-input-container"></div>
									</div>
								</div>
								<button id="paypal_button_submit" class="btn" value="submit"><?php echo $button_pay; ?></button>
							</form>
						</div>
					</div>
					<?php } ?>
				</div>
			</div>
		</div>
	</div>
</div>