<h2><?php echo $text_payment_info; ?></h2>
<div class="alert alert-success" id="opayo-transaction-msg" style="display:none;"></div>
<table class="table table-striped table-bordered">
	<tr>
		<td><?php echo $text_order_ref; ?></td>
		<td><?php echo $opayo_order['VendorTxCode']; ?></td>
	</tr>
	<tr>
		<td><?php echo $text_order_total; ?></td>
		<td><?php echo $opayo_order['total_formatted']; ?></td>
	</tr>
	<tr>
		<td><?php echo $text_total_released; ?></td>
		<td id="payment_opayo-total-released"><?php echo $opayo_order['total_released_formatted']; ?></td>
	</tr>
	<tr>
		<td><?php echo $text_release_status; ?></td>
		<td id="release_status">
			<?php if ($opayo_order['release_status'] == 1) { ?>
			<span class="release_text"><?php echo $text_yes; ?></span>
			<?php } else { ?>
			<span class="release_text"><?php echo $text_no; ?></span>&nbsp;&nbsp;
			<?php if ($opayo_order['void_status'] == 0) { ?>
			<div class="row">
				<div class="col-sm-3">
					<input type="text" width="10" id="release-amount" class="form-control" value="<?php echo $opayo_order['total']; ?>" />
				</div>
				<div class="col-sm-3">
					<a class="button btn btn-primary" id="button-release"><?php echo $button_release; ?></a> <span class="btn btn-primary" id="img-loading-release" style="display:none;"><i class="fa fa-circle-o-notch fa-spin fa-lg"></i></span>
				</div>
			</div>
			<?php } ?>
			<?php } ?>
		</td>
	</tr>
	<tr>
		<td><?php echo $text_void_status; ?></td>
		<td id="void_status">
			<?php if ($opayo_order['void_status'] == 1) { ?>
			<span class="void-text"><?php echo $text_yes; ?></span>
			<?php } elseif (($opayo_order['void_status'] == 0) && ($opayo_order['release_status'] != 1) && ($opayo_order['rebate_status'] != 1)) { ?>
			<span class="void-text"><?php echo $text_no; ?></span>&nbsp;&nbsp;
			<div class="row mb-3">
				<div class="col-sm-3">
					<a class="button btn btn-primary" id="button-void"><?php echo $button_void; ?></a> <span class="btn btn-primary" id="img-loading-void" style="display:none;"><i class="fa fa-circle-o-notch fa-spin fa-lg"></i></span>
				</div>
			</div>
			<?php } else { ?>
			<span class="void-text"><?php echo $text_no; ?></span>
			<?php } ?>
		</td>
	</tr>
	<tr>
		<td><?php echo $text_rebate_status; ?></td>
		<td id="rebate_status">
			<?php if ($opayo_order['rebate_status'] == 1) { ?>
			<span class="rebate-text"><?php echo $text_yes; ?></span>
			<?php } else { ?>
			<span class="rebate-text"><?php echo $text_no; ?></span>&nbsp;&nbsp;
			<?php if (($opayo_order['total_released'] > 0) && ($opayo_order['void_status'] == 0)) { ?>
			<div class="row mb-3">
				<div class="col-sm-3">
					<input type="text" width="10" id="rebate-amount" class="form-control" />
				</div>
				<div class="col-sm-3">
					<a class="button btn btn-primary" id="button-rebate"><?php echo $button_rebate; ?></a> <span class="btn btn-primary" id="img-loading-rebate" style="display:none;"><i class="fa fa-circle-o-notch fa-spin fa-lg"></i></span>
				</div>
			</div>
			<?php } ?>
			<?php } ?>
		</td>
	</tr>
	<tr>
		<td><?php echo $text_transactions; ?>:</td>
		<td>
			<table class="table table-striped table-bordered" id="opayo-transactions">
				<thead>
					<tr>
						<td class="text-left"><strong><?php echo $text_column_date_added; ?></strong></td>
						<td class="text-left"><strong><?php echo $text_column_type; ?></strong></td>
						<td class="text-left"><strong><?php echo $text_column_amount; ?></strong></td>
					</tr>
				</thead>
				<tbody>
					<?php foreach ($opayo_order['transactions'] as $transaction) { ?>
					<tr>
						<td class="text-left"><?php echo $transaction['date_added']; ?></td>
						<td class="text-left"><?php echo $transaction['type']; ?></td>
						<td class="text-left"><?php echo $transaction['amount']; ?></td>
					</tr>
					<?php } ?>
				</tbody>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">

$('#button-void').click(function() {
	if (confirm('<?php echo $text_confirm_void; ?>')) {
		$.ajax({
			type: 'POST',
			dataType: 'json',
			data: {'order_id': <?php echo $order_id; ?>},
			url: 'index.php?route=extension/payment/opayo/void&token=<?php echo $token; ?>',
			beforeSend: function() {
				$('#button-void').hide();
				$('#img-loading-void').show();
				$('#opayo-transaction-msg').hide();
			},
			success: function(data) {
				if (data.error == false) {
					html = '';
					html += '<tr>';
					html += '<td class="text-left">' + data.data.date_added + '</td>';
					html += '<td class="text-left">void</td>';
					html += '<td class="text-left">0.00</td>';
					html += '</tr>';

					$('.void-text').text('<?php echo $text_yes; ?>');
					$('#opayo-transactions').append(html);
					$('#button-release').hide();
					$('#release-amount').hide();

					if (data.msg != '') {
						$('#opayo-transaction-msg').empty().html('<i class="fa fa-check-circle"></i> ' + data.msg).fadeIn();
					}
				}
	
				if (data.error == true) {
					alert(data.msg);
					
					$('#button-void').show();
				}

				$('#img-loading-void').hide();
			},
			error: function(xhr, ajaxOptions, thrownError) {
				console.log(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	}
});

$('#button-release').click(function() {
	if (confirm('<?php echo $text_confirm_release; ?>')) {
		$.ajax({
			type: 'POST',
			dataType: 'json',
			data: {'order_id': <?php echo $order_id; ?>, 'amount': $('#release-amount').val()},
			url: 'index.php?route=extension/payment/opayo/release&token=<?php echo $token; ?>',
			beforeSend: function() {
				$('#button-release').hide();
				$('#release-amount').hide();
				$('#img-loading-release').show();
				$('#opayo-transaction-msg').hide();
			},
			success: function(data) {
				if (data.error == false) {
					html = '';
					html += '<tr>';
					html += '<td class="text-left">' + data.data.date_added + '</td>';
					html += '<td class="text-left">payment</td>';
					html += '<td class="text-left">' + data.data.amount + '</td>';
					html += '</tr>';

					$('#opayo-transactions').append(html);
					$('#opayo-total-released').text(data.data.total);

					if (data.data.release_status == 1) {
						$('#button-void').hide();
						$('.release_text').text('<?php echo $text_yes; ?>');
					} else {
						$('#button-release').show();
						$('#release-amount').val(0.00);

						<?php if ($auto_settle == 2) { ?>
						$('#release-amount').show();
						<?php } ?>
					}

					if (data.msg != '') {
						$('#opayo-transaction-msg').empty().html('<i class="fa fa-check-circle"></i> ' + data.msg).fadeIn();
					}

					$('#button-rebate').show();
					$('#rebate-amount').val(0.00).show();
				}
				
				if (data.error == true) {
					alert(data.msg);
						
					$('#button-release').show();
					$('#release-amount').show();
				}

				$('#img-loading-release').hide();
			},
			error: function(xhr, ajaxOptions, thrownError) {
				console.log(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	}
});

$('#button-rebate').click(function() {
	if (confirm('<?php echo $text_confirm_rebate; ?>')) {
		$.ajax({
			type: 'POST',
			dataType: 'json',
			data: {'order_id': <?php echo $order_id; ?>, 'amount': $('#rebate-amount').val()},
			url: 'index.php?route=extension/payment/opayo/rebate&token=<?php echo $token; ?>',
			beforeSend: function() {
				$('#button-rebate').hide();
				$('#rebate-amount').hide();
				$('#img-loading-rebate').show();
				$('#opayo-transaction-msg').hide();
			},
			success: function(data) {
				if (data.error == false) {
					html = '';
					html += '<tr>';
					html += '<td class="text-left">' + data.data.date_added + '</td>';
					html += '<td class="text-left">rebate</td>';
					html += '<td class="text-left">' + data.data.amount + '</td>';
					html += '</tr>';

					$('#opayo-transactions').append(html);
					$('#opayo-total-released').text(data.data.total_released);

					if (data.data.rebate_status == 1) {
						$('.rebate-text').text('<?php echo $text_yes; ?>');
					} else {
						$('#button-rebate').show();
						$('#rebate-amount').val(0.00).show();
					}

					if (data.msg != '') {
						$('#opayo-transaction-msg').empty().html('<i class="fa fa-check-circle"></i> ' + data.msg).fadeIn();
					}
				}
				
				if (data.error == true) {
					alert(data.msg);
					
					$('#button-rebate').show();
				}

				$('#img-loading-rebate').hide();
			},
			error: function(xhr, ajaxOptions, thrownError) {
				console.log(thrownError + "\r\n" + xhr.statusText + "\r\n" + xhr.responseText);
			}
		});
	}
});

</script>