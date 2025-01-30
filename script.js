// ==UserScript==
// @name         Telegram Invite Link Auto-Clicker
// @namespace    http://tampermonkey.net/
// @version      1.3
// @description  Automatically clicks on Telegram invite links and joins the group
// @author       Culex
// @match        *://web.telegram.org/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    function clickJoinGroupButton() {
        const joinButton = document.querySelector('.HeaderActions button.Button.tiny.primary.fluid.has-ripple');

        if (joinButton) {
            if (joinButton.offsetParent !== null && !joinButton.disabled) {
                const mouseDownEvent = new MouseEvent('mousedown', { bubbles: true, cancelable: true });
                const mouseUpEvent = new MouseEvent('mouseup', { bubbles: true, cancelable: true });
                const clickEvent = new MouseEvent('click', { bubbles: true, cancelable: true });

                joinButton.dispatchEvent(mouseDownEvent);
                joinButton.dispatchEvent(mouseUpEvent);
                joinButton.dispatchEvent(clickEvent);

                console.log('Clicked the "Join Group" button.');
            } else {
                console.log('Button is not clickable yet.');
            }
        } else {
            console.log('Could not find the "Join Group" button.');
        }
    }

    function waitForJoinGroupButton() {
        const maxAttempts = 10;
        let attempts = 0;

        const interval = setInterval(() => {
            clickJoinGroupButton();

            attempts++;
            if (attempts >= maxAttempts) {
                clearInterval(interval);
                console.log('Stopped looking for the "Join Group" button.');
            }
        }, 1000);
    }

    const observer = new MutationObserver((mutations) => {
        mutations.forEach(mutation => {
            mutation.addedNodes.forEach(node => {
                if (node.nodeType === 1) {
                    const links = node.querySelectorAll('a');
                    links.forEach(link => {
                        if (link.href && link.href.startsWith('https://t.me/') && !link.dataset.clicked) {
                            link.dataset.clicked = true;

                            link.click();
                            console.log('Clicked on new Telegram invite link:', link.href);

                            waitForJoinGroupButton();
                        }
                    });
                }
            });
        });
    });

    function observeChat() {
        const chatContainer = document.querySelector('[class^="messages-container"]');
        if (chatContainer) {
            observer.observe(chatContainer, { childList: true, subtree: true });
            console.log('Observing chat for new messages...');
        } else {
            console.log('Chat container not found. Retrying...');
            setTimeout(observeChat, 2000);
        }
    }

    window.addEventListener('load', observeChat);
})();
