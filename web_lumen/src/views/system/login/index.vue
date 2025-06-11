<!--
@File    : index.vue
@Time    : 2025-04-09 11:12:24
@Author  : JackGong
-->

<template>
	<div class="login-container flex z-10">
		<div class="login-right flex z-10">
			<div class="login-right-warp flex-margin">
				<div class="login-right-warp-mian">
					<div class="login-right-warp-main-title" style="font-size: large;">
            {{userInfos.pwd_change_count===0?'初次登录修改密码':'欢迎登录'}}
          </div>
					<div class="login-right-warp-main-form">
						<div v-if="!state.isScan">
              <el-tabs v-model="state.tabsActiveName">
                <el-tab-pane
                    :label="$t('message.label.changePwd')"
                    name="changePwd"
                    v-if="userInfos.pwd_change_count === 0"
                >
                  <ChangePwd />
                </el-tab-pane>

                <el-tab-pane
                    :label="$t('message.label.one1')"
                    name="account"
                    v-else
                >
                  <Account />
                </el-tab-pane>

                <el-tab-pane
                    :label="$t('message.label.two2')"
                    name="dingScan"
                >
                  <DingScan />
                </el-tab-pane>
              </el-tabs>
						</div>
<!--						<Scan v-if="state.isScan" />-->
<!--						<div class="login-content-main-sacn" @click="state.isScan = !state.isScan">-->
<!--							<i class="iconfont" :class="state.isScan ? 'icon-diannao1' : 'icon-barcode-qr'"></i>-->
<!--							<div class="login-content-main-sacn-delta"></div>-->
<!--						</div>-->
					</div>
				</div>
			</div>
		</div>

    <div class="login-left">
<!--      			<div class="login-left-logo">-->
<!--      				<img :src="siteLogo" />-->
<!--      				<div class="login-left-logo-text">-->
<!--      					<span>{{ getSystemConfig['login.site_title'] || getThemeConfig.globalViceTitle }}</span>-->
<!--      					<span class="login-left-logo-text-msg" style="margin-top: 5px;">{{-->
<!--      						getSystemConfig['login.site_name'] || getThemeConfig.globalViceTitleMsg }}</span>-->
<!--      				</div>-->
<!--      			</div>-->
    </div>

<!--		<div class="login-authorization z-10">-->
<!--			<p>Copyright © {{ getSystemConfig['login.copyright'] || '2021-2024 北京信码新创科技有限公司' }} 版权所有</p>-->
<!--			<p class="la-other" style="margin-top: 5px;">-->
<!--				<a href="https://beian.miit.gov.cn" target="_blank">{{ getSystemConfig['login.keep_record'] ||-->
<!--					'京ICP备2021031018号' }}</a>-->
<!--				|-->
<!--				<a :href="getSystemConfig['login.help_url'] ? getSystemConfig['login.help_url'] : '#'"-->
<!--					target="_blank">帮助</a>-->
<!--				|-->
<!--				<a-->
<!--					:href="getSystemConfig['login.privacy_url'] ? getBaseURL(getSystemConfig['login.privacy_url']) : '#'">隐私</a>-->
<!--				|-->
<!--				<a-->
<!--					:href="getSystemConfig['login.clause_url'] ? getBaseURL(getSystemConfig['login.clause_url']) : '#'">条款</a>-->
<!--			</p>-->
<!--		</div>-->
	</div>
	<div v-if="loginBg">
    <img
        :src="loginBg"
        class="loginBg fixed inset-0 z-1 w-full h-full fixed inset-0"
        alt="background"
    />
	</div>
</template>

<script setup lang="ts" name="loginIndex">
import {defineAsyncComponent, onMounted, reactive, computed, watch} from 'vue';
import { storeToRefs } from 'pinia';
import { useThemeConfig } from '/@/stores/themeConfig';
import { NextLoading } from '/@/utils/loading';
import logoMini from '/@/assets/logo-mini.svg';
import loginMain from '/@/assets/login-main.svg';
import loginBg from '/@/assets/login-bg.png';
import { SystemConfigStore } from '/@/stores/systemConfig'
import { getBaseURL } from "/@/utils/baseUrl";
// 引入组件
const Account = defineAsyncComponent(() => import('/@/views/system/login/component/account.vue'));
const Mobile = defineAsyncComponent(() => import('/@/views/system/login/component/mobile.vue'));
const DingScan = defineAsyncComponent(() => import('/@/views/system/login/component/dingScan.vue'));
const Scan = defineAsyncComponent(() => import('/@/views/system/login/component/scan.vue'));
const ChangePwd = defineAsyncComponent(() => import('/@/views/system/login/component/changePwd.vue'));
import _ from "lodash-es";
import {useUserInfo} from "/@/stores/userInfo";
const { userInfos } = storeToRefs(useUserInfo());

// 定义变量内容
const storesThemeConfig = useThemeConfig();
const { themeConfig } = storeToRefs(storesThemeConfig);
const state = reactive({
	tabsActiveName: 'account',
	isScan: false,
});


watch(()=>userInfos.value.pwd_change_count,(val)=>{
  if(val===0){
    state.tabsActiveName ='changePwd'
  }else{
    state.tabsActiveName ='account'
  }
},{deep:true,immediate:true})


// 获取布局配置信息
const getThemeConfig = computed(() => {
	return themeConfig.value;
});

const systemConfigStore = SystemConfigStore()
const { systemConfig } = storeToRefs(systemConfigStore)
const getSystemConfig = computed(() => {
	return systemConfig.value
})

const siteLogo = computed(() => {
	if (!_.isEmpty(getSystemConfig.value['login.site_logo'])) {
		return getSystemConfig.value['login.site_logo']
	}
	return logoMini
});

const siteBg = computed(() => {
	if (!_.isEmpty(getSystemConfig.value['login.login_background'])) {
		return getSystemConfig.value['login.login_background']
	}
});

// 页面加载时
onMounted(() => {
	NextLoading.done();
});
</script>

<style scoped lang="scss">
//.login-right-warp {
//  position: fixed;
//  top: 0;
//  left: 0;
//  width: 400px; /* 固定宽度，你可以根据需求调整 */
//  //height: 100vh; /* 占满整个页面高度 */
//  background-color: #fff; /* 根据你主题设置背景色，避免透明 */
//  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1); /* 可选，添加阴影美观 */
//  z-index: 1000; /* 避免被其他元素覆盖 */
//  padding: 20px;
//  overflow-y: auto; /* 内容过多时滚动 */
//}
.el-tab-pane {
  min-height: 320px; /* 自定义高度，例如 400px */
  padding: 20px;      /* 可选，增加内边距 */
  box-sizing: border-box;
}
::v-deep(.el-tabs__item.is-active) {
  color: #FFAB4F !important;
  border-bottom: 2px solid #FFAB4F !important;
}
::v-deep(.el-tabs__item) {
  transition: all 0.3s ease;
}
::v-deep(.el-tabs__item:hover) {
  color: #FFAB4F;
}
/* 激活标签的文字颜色和底部边框 */
::v-deep(.el-tabs__item.is-active) {
  color: #FFAB4F !important;
  border-bottom: 2px solid #FFAB4F !important;
}
/* 修改 Tab 激活滑块条颜色 */
::v-deep(.el-tabs__active-bar) {
  background-color: #FFAB4F !important;
}

.login-right-warp {
  background-color: #ffffff; // 白色背景
  padding: 40px 50px; // 内边距，让白色背景比内容大
  border-radius: 12px; // 圆角边框
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); // 阴影
  position: fixed;
  width: 400px;
  height: 450px;
  top: 300px;
  left: 200px;
  z-index: 2;
  margin-top: -20px; // 向上“扩展”
  margin-right: -20px; // 向右“扩展”
  margin-left: 0; // 向左稍微贴近
  transition: all 0.3s ease;

  .login-right-warp-mian {
    width: 100%;
    height: 100%;
    //.login-right-warp-main-form {
    //
    //}
  }
}

.login-container {
  height: 100vh;
  background: var(--el-color-white);
  display: flex;
  justify-content: center;
  align-items: center;

  .login-left {
    background-color: rgba(211, 239, 255, 1);
    display: flex;
    justify-content: center;
    align-items: center;
    flex: 1;
    position: relative;
    width: 50vw;  /* 宽度占屏幕宽度的50% */
    height: 60vh; /* 高度占屏幕高度的60% */
    max-width: 700px; /* 最大宽度限制 */
    max-height: 500px; /* 最大高度限制 */
    min-width: 300px; /* 最小宽度限制 */
    min-height: 400px; /* 最小高度限制 */
    margin-left: 5vw; /* 使其不贴边 */
    border-radius: 15px;

    .login-left-logo {
      position: absolute;
      top: 5vh;
      left: 5vw;
      z-index: 1;
      animation: logoAnimation 0.3s ease;

      img {
        width: 8vw; /* 根据视口宽度调整logo大小 */
        height: 8vw; /* 根据视口宽度调整logo大小 */
      }

      .login-left-logo-text {
        display: flex;
        flex-direction: column;
        margin-left: 10px;

        span {
          font-size: 1.5vw;
          color: var(--el-color-primary);
        }

        .login-left-logo-text-msg {
          font-size: 1vw;
          color: var(--el-color-primary);
        }
      }
    }

    .login-left-img {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      width: 100%;
      height: 50%;
      max-height: 300px;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        animation: error-num 0.6s ease;
      }
    }
  }

  .login-right {
    flex: 1;
    max-width: 400px;
    min-width: 320px;
    padding: 20px;
    margin-top: 20vh;
    margin-right: 30vh;
  }

  .login-authorization {
    position: absolute;
    bottom: 30px;
    left: 0;
    right: 0;
    text-align: center;
    font-size: 1vw;

    p {
      color: rgba(0, 0, 0, 0.5);
    }

    a {
      color: var(--el-color-primary);
      margin: 0 5px;
    }
  }
}


</style>
