{**
 * templates/frontend/components/languageSwitcher.tpl
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief A re-usable template for displaying a language switcher dropdown.
 *
 * @uses $currentLocale string Locale key for the locale being displayed
 * @uses $languageToggleLocales array All supported locales
 * @uses $id string A unique ID for this language toggle
 *}

{if $languageToggleLocales && $languageToggleLocales|@count > 1}
	<ul id="{$id|escape}" class="dropdown language-toggle nav nav-tabs">
		<li class="nav-item dropdown">
			<button class="nav-link dropdown-toggle spup-header__language-button" type="button" id="languageToggleMenu{$id|escape}" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				<span class="visually-hidden">{translate key="plugins.themes.spupLightExplorerTheme.language.toggle"}</span>
				{$languageToggleLocales[$currentLocale]|escape}
			</button>

			<div class="navigation-dropdown dropdown-menu dropdown-menu-end" aria-labelledby="languageToggleMenu{$id|escape}">
				{foreach from=$languageToggleLocales item="localeName" key="localeKey"}
					{if $localeKey !== $currentLocale}
						<a class="dropdown-item" href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey}">
							{$localeName|escape}
						</a>
					{/if}
				{/foreach}
			</div>
		</li>
	</ul>
{/if}
