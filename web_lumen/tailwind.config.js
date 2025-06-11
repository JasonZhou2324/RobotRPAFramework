/**
 * @File    : tailwind.config.js
 * @Time    : 2025-04-09 11:12:24
 * @Author  : JackGong
 */

/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./index.html', './src/**/*.{vue,js}'],
	theme: {
		extend: {
			height: {
				'screen/2': '50vh',
			},
		},
	},
	plugins: [],
};
