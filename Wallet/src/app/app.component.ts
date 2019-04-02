import {Component, OnInit} from '@angular/core';
import {NavigationEnd, Router} from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
    title = 'wallet';
    clientConnected = true;

    constructor(router: Router) {
        this.startRouteListener(router);
    }

    ngOnInit() {
    }

    private startRouteListener(router: Router) {
        // router.events.subscribe((url: NavigationEnd) => {
        //   if (url instanceof NavigationEnd && url.urlAfterRedirects) {
        //
        //     const htmlNavBar = document.getElementById('main-nav-bar');
        //     const htmlATagElements = htmlNavBar.getElementsByTagName('a');
        //
        //     // for ( const htmlAElem of [].slice.call(htmlATagElements)) {
        //     //     htmlAElem.classList.remove('active');
        //     // }
        //
        //   //   const htmlActiveATagElement = document.getElementById(url.urlAfterRedirects.substr(1));
        //   //   htmlActiveATagElement.classList.add('active');
        //   // }
        // });
    }
}
