defmodule SorteiosWeb.ProfileLive.Wallet do
  use SorteiosWeb, :live_view

  on_mount {SorteiosWeb.LiveUserAuth, :live_user_required}

  def mount(_params, _session, socket) do
    my_rifas = Sorteios.Prizes.list_rifas_by_user!(actor: socket.assigns.current_user)

    {:ok, assign(socket, :my_rifas, my_rifas)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app {assigns}>
      <div class="flex h-full flex-col">
        <!-- Sticky search header -->
        <div class="sticky top-0 z-40 flex h-16 shrink-0 items-center gap-x-6 border-b border-gray-200 bg-white px-4 shadow-xs sm:px-6 lg:px-8 dark:border-white/5 dark:bg-gray-900 dark:shadow-none">
          <button
            type="button"
            command="show-modal"
            commandfor="sidebar"
            class="-m-2.5 p-2.5 text-gray-900 xl:hidden dark:text-white"
          >
            <span class="sr-only">Open sidebar</span>
            <svg
              viewBox="0 0 20 20"
              fill="currentColor"
              data-slot="icon"
              aria-hidden="true"
              class="size-5"
            >
              <path
                d="M2 4.75A.75.75 0 0 1 2.75 4h14.5a.75.75 0 0 1 0 1.5H2.75A.75.75 0 0 1 2 4.75ZM2 10a.75.75 0 0 1 .75-.75h14.5a.75.75 0 0 1 0 1.5H2.75A.75.75 0 0 1 2 10Zm0 5.25a.75.75 0 0 1 .75-.75h14.5a.75.75 0 0 1 0 1.5H2.75a.75.75 0 0 1-.75-.75Z"
                clip-rule="evenodd"
                fill-rule="evenodd"
              />
            </svg>
          </button>

          <div class="flex flex-1 gap-x-4 self-stretch lg:gap-x-6">
            <form action="#" method="GET" class="grid flex-1 grid-cols-1">
              <input
                name="search"
                placeholder="Search"
                aria-label="Search"
                class="col-start-1 row-start-1 block size-full bg-transparent pl-8 text-base text-gray-900 outline-hidden placeholder:text-gray-400 sm:text-sm/6 dark:text-white dark:placeholder:text-gray-500"
              />
              <svg
                viewBox="0 0 20 20"
                fill="currentColor"
                data-slot="icon"
                aria-hidden="true"
                class="pointer-events-none col-start-1 row-start-1 size-5 self-center text-gray-400 dark:text-gray-500"
              >
                <path
                  d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z"
                  clip-rule="evenodd"
                  fill-rule="evenodd"
                />
              </svg>
            </form>
          </div>
        </div>

        <main>
          <header>
            <!-- Secondary navigation -->

            <div class="grid grid-cols-1 bg-gray-50 sm:grid-cols-2 lg:grid-cols-4 dark:bg-gray-700/10">
              <div class="border-t border-gray-200/50 px-4 py-6 sm:px-6 lg:px-8 dark:border-white/5">
                <p class="text-sm/6 font-medium text-gray-500 dark:text-gray-400">
                  Number of deploys
                </p>
                <p class="mt-2 flex items-baseline gap-x-2">
                  <span class="text-4xl font-semibold tracking-tight text-gray-900 dark:text-white">
                    405
                  </span>
                </p>
              </div>
              <div class="border-t border-gray-200/50 px-4 py-6 sm:border-l sm:px-6 lg:px-8 dark:border-white/5">
                <p class="text-sm/6 font-medium text-gray-500 dark:text-gray-400">
                  Average deploy time
                </p>
                <p class="mt-2 flex items-baseline gap-x-2">
                  <span class="text-4xl font-semibold tracking-tight text-gray-900 dark:text-white">
                    3.65
                  </span>
                  <span class="text-sm text-gray-500 dark:text-gray-400">mins</span>
                </p>
              </div>
              <div class="border-t border-gray-200/50 px-4 py-6 sm:px-6 lg:border-l lg:px-8 dark:border-white/5">
                <p class="text-sm/6 font-medium text-gray-500 dark:text-gray-400">
                  Number of servers
                </p>
                <p class="mt-2 flex items-baseline gap-x-2">
                  <span class="text-4xl font-semibold tracking-tight text-gray-900 dark:text-white">
                    3
                  </span>
                </p>
              </div>
              <div class="border-t border-gray-200/50 px-4 py-6 sm:border-l sm:px-6 lg:px-8 dark:border-white/5">
                <p class="text-sm/6 font-medium text-gray-500 dark:text-gray-400">Success rate</p>
                <p class="mt-2 flex items-baseline gap-x-2">
                  <span class="text-4xl font-semibold tracking-tight text-gray-900 dark:text-white">
                    98.5%
                  </span>
                </p>
              </div>
            </div>
          </header>

          <div class="border-t border-gray-200 pt-11 dark:border-white/10">
            <h2 class="px-4 text-base/7 font-semibold text-gray-900 sm:px-6 lg:px-8 dark:text-white">
              Latest activity
            </h2>
            <table class="mt-6 w-full text-left whitespace-nowrap">
              <colgroup>
                <col class="w-full sm:w-4/12" />
                <col class="lg:w-4/12" />
                <col class="lg:w-2/12" />
                <col class="lg:w-1/12" />
                <col class="lg:w-1/12" />
              </colgroup>
              <thead class="border-b border-gray-200 text-sm/6 text-gray-900 dark:border-white/10 dark:text-white">
                <tr>
                  <th scope="col" class="py-2 pr-8 pl-4 font-semibold sm:pl-6 lg:pl-8">User</th>
                  <th scope="col" class="hidden py-2 pr-8 pl-0 font-semibold sm:table-cell">
                    Commit
                  </th>
                  <th
                    scope="col"
                    class="py-2 pr-4 pl-0 text-right font-semibold sm:pr-8 sm:text-left lg:pr-20"
                  >
                    Status
                  </th>
                  <th scope="col" class="hidden py-2 pr-8 pl-0 font-semibold md:table-cell lg:pr-20">
                    Duration
                  </th>
                  <th
                    scope="col"
                    class="hidden py-2 pr-4 pl-0 text-right font-semibold sm:table-cell sm:pr-6 lg:pr-8"
                  >
                    Description
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-100 dark:divide-white/5">
                <tr :for={rifa <- @my_rifas}>
                  <td class="py-4 pr-8 pl-4 sm:pl-6 lg:pl-8">
                    <div class="flex items-center gap-x-4">
                      <img
                        src="https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                        alt=""
                        class="size-8 rounded-full bg-gray-100 outline -outline-offset-1 outline-black/5 dark:bg-gray-800 dark:outline-white/10"
                      />
                      <div class="truncate text-sm/6 font-medium text-gray-900 dark:text-white">
                        {rifa.name}
                      </div>
                    </div>
                  </td>
                  <td class="hidden py-4 pr-4 pl-0 sm:table-cell sm:pr-8">
                    <div class="flex gap-x-3">
                      <div class="font-mono text-sm/6 text-gray-500 dark:text-gray-400">2d89f0c8</div>
                      <span class="inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-xs font-medium text-gray-600 ring-1 ring-gray-300 ring-inset dark:bg-gray-400/10 dark:text-gray-400 dark:ring-gray-400/20">
                        main
                      </span>
                    </div>
                  </td>
                  <td class="py-4 pr-4 pl-0 text-sm/6 sm:pr-8 lg:pr-20">
                    <div class="flex items-center justify-end gap-x-2 sm:justify-start">
                      <time
                        datetime="2023-01-23T11:00"
                        class="text-gray-500 sm:hidden dark:text-gray-400"
                      >
                        45 minutes ago
                      </time>
                      <div class="flex-none rounded-full bg-green-500/10 p-1 text-green-500 dark:bg-green-400/10 dark:text-green-400">
                        <div class="size-1.5 rounded-full bg-current"></div>
                      </div>
                      <div class="hidden text-gray-900 sm:block dark:text-white">{rifa.status}</div>
                    </div>
                  </td>
                  <td class="hidden py-4 pr-8 pl-0 text-sm/6 text-gray-500 md:table-cell lg:pr-20 dark:text-gray-400">
                    25s
                  </td>
                  <td class="hidden py-4 pr-4 pl-0 text-right text-sm/6 text-gray-500 sm:table-cell sm:pr-6 lg:pr-8 dark:text-gray-400">
                    {rifa.description}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </main>
      </div>
    </Layouts.app>
    """
  end
end
