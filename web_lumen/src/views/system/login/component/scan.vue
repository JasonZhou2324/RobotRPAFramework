<!--
@File    : scan.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<div class="login-scan-container">
		<div ref="qrcodeRef"></div>
		<div class="font12 mt20 login-msg">{{ $t('message.scan.text') }}</div>
	</div>
</template>

<script lang="ts">
import { ref, defineComponent, onMounted } from 'vue';
import QRCode from 'qrcodejs2-fixes';

export default defineComponent({
	name: 'loginScan',
	setup() {
		const qrcodeRef = ref<HTMLElement | null>(null);
		// 初始化生成二维码
		const initQrcode = () => {
			(qrcodeRef.value as HTMLElement).innerHTML = '';
			new QRCode(qrcodeRef.value, {
				text: `https://jq.qq.com/?_wv=1027&k=hUu2GeU1`,
				width: 260,
				height: 260,
				colorDark: '#000000',
				colorLight: '#ffffff',
			});
		};
		// 页面加载时
		onMounted(() => {
			initQrcode();
		});
		return { qrcodeRef };
	},
});
</script>

<style scoped lang="scss">
.login-scan-animation {
	opacity: 0;
	animation-name: error-num;
	animation-duration: 0.5s;
	animation-fill-mode: forwards;
}
.login-scan-container {
	padding: 20px;
	display: flex;
	flex-direction: column;
	text-align: center;
	@extend .login-scan-animation;
	animation-delay: 0.1s;
	:deep(img) {
		margin: auto;
	}
	.login-msg {
		color: #1f1f1f !important;
		@extend .login-scan-animation;
		animation-delay: 0.2s;
	}
}
</style>
